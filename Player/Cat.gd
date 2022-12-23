extends KinematicBody2D
#cat & kitten
const SPEED=350   #walking speed
const FOOD=10
const ENEMY=20
const MAXSPEED=500
const JUMP_VELOCITY=-600
const KITTEN_MOD=1.2 #jumping modifiyer
const SCALE=Vector2(0.5,0.5)

enum {JUMP,SIT,WALK,RUN}
var Animate_Name=["Jump","Sit","Walk","Run"]
var Animate_Mode="Kitten"
var velocity=Vector2()
var Life=true
var animfinish=true


signal Food
signal Enemy
signal Message(message)

func _ready():
	set_scale(SCALE)
	Global.Cat=self
	randomize()
	$AnimatedSprite.playing=true
	$jumptimer.wait_time=0.5
#	Global.PlayerAlive=true
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
	if Input.is_action_pressed("ui_cancel"):
		Global.saveGameState()
		Global.PlayerAlive=false
	
func _process(delta): 
	animate()
	
func PickAnimation(an_type=0) -> String: #pick from enum
	if Global.isChild:
		return Animate_Mode+Animate_Name[an_type]
	else:
		return Animate_Name[an_type]
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	elif is_on_ceiling():
		velocity.y=1
	else:
		velocity.y+=Global.GRAVITY*delta
		
func jump():
	if !Life: return
	if Input.is_action_pressed("ui_up") and is_on_floor():
		$jumptimer.start()		
		velocity.y=JUMP_VELOCITY-Global.Stamina*2-abs(velocity.x/3)
		if Global.isChild:
			velocity.y=velocity.y/KITTEN_MOD #makes jumps shorter for kitten
		set_collision_mask_bit(Global.PLATFORM,false)
		if Global.Stamina>10: Global.Stamina-=0.2
		
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		$jumptimer.start()
		set_collision_mask_bit(Global.PLATFORM,false)
			
func run(delta):
	if !Life: return
	if Input.is_action_pressed("ui_runright"):#and not Input.is_action_pressed("ui_runright"):
		if velocity.x<MAXSPEED:
			velocity.x+=MAXSPEED*delta
		else:
			velocity.x=MAXSPEED
		$AnimatedSprite.flip_h=true #face right
	elif Input.is_action_pressed("ui_runleft"):#and not Input.is_action_pressed("ui_runright"):
		if velocity.x>-MAXSPEED:
			velocity.x-=MAXSPEED*delta
		else:
			velocity.x=-MAXSPEED
		$AnimatedSprite.flip_h=false #face left
	else:
		if velocity.x>0:
			velocity.x-=MAXSPEED*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0:
			velocity.x+=MAXSPEED*delta
			if velocity.x>0:
				velocity.x=0
		
func animate():
	if !Life:
		return
	if velocity.y!=0 && !is_on_floor():
		$AnimatedSprite.speed_scale=3
		$AnimatedSprite.play(PickAnimation(JUMP))
	if velocity.x==0 && is_on_floor():
		$AnimatedSprite.speed_scale=0.1
		$AnimatedSprite.play(PickAnimation(SIT))
	elif abs(velocity.x)<=SPEED && is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play(PickAnimation(WALK))
	elif abs(velocity.x)>SPEED && is_on_floor():
		$AnimatedSprite.speed_scale=3
		$AnimatedSprite.play(PickAnimation(RUN))
		
func _on_jumptimer_timeout():
		set_collision_mask_bit(Global.PLATFORM,true)

func _on_Cat_Food():
	if Global.Stamina<100:
		Global.Stamina+=FOOD
		if Global.Stamina>100:
			Global.Stamina=100

func _on_Cat_Enemy():
#if enemy is meet
	if !Life:
		return
#	set_collision_mask_bit(Global.PLATFORM,false)
#	set_collision_mask_bit(Global.GROUND,false)
#	$AnimatedSprite.flip_v=true
#	$AnimatedSprite.rotate(rand_range(0.0,1.0))
	Life=false #die
	Global.LifesLeft-=1 #decrease lifes counter
	Global.saveGameState()
	pass # Replace with function body.

func deathcheck(): 
	if Global.Stamina<=0 || velocity.y>1500 || !Life:
		Global.PlayerAlive=false #die if trigered by highfall or stamina
		queue_free()

#message handling
func _on_Cat_Message(message):
	$Cam/HUD/HUDPanel/Message.text=str(message)
	$messagetimer.start(5)
func _on_messagetimer_timeout():
	$Cam/HUD/HUDPanel/Message.text=""
