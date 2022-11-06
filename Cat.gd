extends KinematicBody2D


const SPEED=350   #walking speed
const MAXSPEED=500
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
var collision

func _ready():
	randomize()
	$AnimatedSprite.playing=true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# slower movement goes to the end!
func _physics_process(delta):
	#---FASTER---
	fall(delta)
	jump()
	run(delta)
	#walk(delta)
	#---SLOWER---
	move_and_slide(velocity,UP)
	

func _process(delta): 
	animate()
	
func fall(delta):
	if is_on_floor() or is_on_ceiling():
		velocity.y=0
	else:
		velocity.y+=GRAVITY*delta
		
func jump():
	if Input.is_action_pressed("ui_up") and is_on_floor():
		$jumptimer.start()		
		velocity.y=JUMP_VELOCITY
		set_collision_mask_bit(PLATFORM,false)
	elif Input.is_action_pressed("ui_down") and is_on_floor():
		$jumptimer.start()
		set_collision_mask_bit(PLATFORM,false)
			
func run(delta):
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
		
		
func animate():
	var taleswing=randf()/2
	var zoom=abs(velocity.x)*0.5/MAXSPEED+1
	$Cam.set_zoom(Vector2(zoom,zoom))
	if velocity.y!=0 and !is_on_floor():
		$AnimatedSprite.speed_scale=5
		$AnimatedSprite.play("Jump")
	if velocity.x==0 and is_on_floor():
		$AnimatedSprite.speed_scale=taleswing
		$AnimatedSprite.play("Sit")
	elif abs(velocity.x)<=SPEED and is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play("Walk")
	elif abs(velocity.x)>SPEED and is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play("Run")
		
func _on_jumptimer_timeout():
	set_collision_mask_bit(PLATFORM,true)
	
