extends KinematicBody2D


const SPEED=250   #walk speed
const RSPEED=500  #run speed
const GRAVITY=1400
const JUMP_VELOCITY=-700
const UP=Vector2(0,-1)
# layer bit numbering starts from 0
# layer 0 is a player
const GROUND=1 				# ground layer, user cant jump off the ground 
const PLATFORM=2            # platforms layer, user can jump on and off the platform
							 
var velocity=Vector2()
var Life=100
var Power=100

func _ready():
	randomize()
	$AnimatedSprite.playing=false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# slower movement goes to the end!
func _physics_process(delta):
	#---FASTER---
	fall(delta)
	jump()
	jumpdown() # jump of the platform (while press down togle mask bit 1 for 0.5 sec)
	run(delta)
	walk(delta)
	#---SLOWER---
	move_and_slide(velocity,UP)

func _process(delta): 
	animate()
	
func fall(delta):
	if is_on_floor() or is_on_ceiling():
		velocity.y=0
	else:
		velocity.y+=GRAVITY*delta
		
func jumpdown():
	if Input.is_action_pressed("ui_down") and is_on_floor():
		$jumptimer.start()
		set_collision_mask_bit(PLATFORM,false)
			
func jump():
	if Input.is_action_pressed("ui_up") and is_on_floor():
		$jumptimer.start()		
		velocity.y=JUMP_VELOCITY
		set_collision_mask_bit(PLATFORM,false)

func run(delta):
	if Input.is_action_pressed("ui_runright"):#and not Input.is_action_pressed("ui_runright"):
		velocity.x=RSPEED
		$AnimatedSprite.flip_h=true
	elif Input.is_action_pressed("ui_runleft"):#and not Input.is_action_pressed("ui_runright"):
		velocity.x=-RSPEED
		$AnimatedSprite.flip_h=false
	else:
		if velocity.x>0:
			velocity.x-=RSPEED*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0:
			velocity.x+=RSPEED*delta
			if velocity.x>0:
				velocity.x=0
		
			
func walk(delta):
	if Input.is_action_pressed("ui_walkright"):#and not Input.is_action_pressed("ui_runright"):
		velocity.x=SPEED
		$AnimatedSprite.flip_h=true
	elif Input.is_action_pressed("ui_walkleft"):#and not Input.is_action_pressed("ui_runright"):
		velocity.x=-SPEED
		$AnimatedSprite.flip_h=false
	else:
		if velocity.x>0:
			velocity.x-=SPEED*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0:
			velocity.x+=SPEED*delta
			if velocity.x>0:
				velocity.x=0
		
func animate():
	var taleswing=randf()/2
	var vx=abs(velocity.x)
	if vx<=SPEED and is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play("Walk")
	if vx>SPEED and is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play("Run")
	if vx==0 and is_on_floor():
		$AnimatedSprite.speed_scale=taleswing
		$AnimatedSprite.play("Sit")
	if velocity.y!=0 and !is_on_floor():
		$AnimatedSprite.speed_scale=5
		$AnimatedSprite.play("Jump")
			

func _on_jumptimer_timeout():
	set_collision_mask_bit(PLATFORM,true)
	
