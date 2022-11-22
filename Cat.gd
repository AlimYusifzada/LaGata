extends KinematicBody2D
#cat
const SPEED=350   #walking speed
const FOOD=10
const ENEMY=20
const MAXSPEED=500
const JUMP_VELOCITY=-600
const SCALE=Vector2(0.5,0.5)
var velocity=Vector2()
var Stamina=10	#initial value
var Life=true

signal Food
signal Enemy

func _ready():
	set_scale(SCALE)
	Global.Cat=self
	randomize()
	$AnimatedSprite.playing=true
	$jumptimer.wait_time=0.5
	Life=true
	pass # Replace with function body.

func _physics_process(delta):
	#---FASTER---
	deathcheck()
	fall(delta)
	jump()
	run(delta)
	#---SLOWER---
	move_and_slide(velocity,Global.UP)
	

func _process(delta): 
	animate()
	
func fall(delta) -> void:
	if is_on_floor():
		velocity.y=0
	elif is_on_ceiling():
		velocity.y=1
	else:
		velocity.y+=Global.GRAVITY*delta
		
func jump() -> void:
	if Input.is_action_pressed("ui_up") and is_on_floor():
		$jumptimer.start()		
		velocity.y=JUMP_VELOCITY-Stamina*2-abs(velocity.x/3)
		set_collision_mask_bit(Global.PLATFORM,false)
		if Stamina>10: Stamina-=1
		
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		$jumptimer.start()
		set_collision_mask_bit(Global.PLATFORM,false)
			
func run(delta) -> void:
	if Input.is_action_pressed("ui_runright"):#and not Input.is_action_pressed("ui_runright"):
		if velocity.x<MAXSPEED:
			velocity.x+=MAXSPEED*delta
		else:
			velocity.x=MAXSPEED
		$AnimatedSprite.flip_h=true
	elif Input.is_action_pressed("ui_runleft"):#and not Input.is_action_pressed("ui_runright"):
		if velocity.x>-MAXSPEED:
			velocity.x-=MAXSPEED*delta
		else:
			velocity.x=-MAXSPEED
		$AnimatedSprite.flip_h=false
	else:
		if velocity.x>0:
			velocity.x-=MAXSPEED*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0:
			velocity.x+=MAXSPEED*delta
			if velocity.x>0:
				velocity.x=0
		
func animate() -> void:
	$Cam/HUD/ColorRect/Stamina.text=str(Stamina)
	if velocity.y!=0 and !is_on_floor():
		$AnimatedSprite.speed_scale=3
		$AnimatedSprite.play("Jump")
	if velocity.x==0 and is_on_floor():
		$AnimatedSprite.speed_scale=0.1
		$AnimatedSprite.play("Sit")
	elif abs(velocity.x)<=SPEED and is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play("Walk")
	elif abs(velocity.x)>SPEED and is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play("Run")
		
func _on_jumptimer_timeout() -> void:
		set_collision_mask_bit(Global.PLATFORM,true)

func _on_Cat_Food() -> void:
	if Stamina<100:
		Stamina+=FOOD
		if Stamina>100:
			Stamina=100

func _on_Cat_Enemy() -> void:
	set_collision_mask_bit(Global.PLATFORM,false)
	set_collision_mask_bit(Global.GROUND,false)
	pass # Replace with function body.

func deathcheck() -> void:
	if Stamina<=0 || velocity.y>1500 || !Life:
		queue_free()
