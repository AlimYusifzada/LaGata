extends KinematicBody2D


const SPEED=250
const GRAVITY=1400
const JUMP_VELOCITY=-700
const INERTIA=SPEED
const UP=Vector2(0,-1)
const PLATFORM=1            # platforms layer, user can jump on and off the platform
const GROUND=2 				# ground layer, user cant jump off the ground 
							# layer 0 is a player 
var velocity=Vector2()
var Life=100
var Power=100

func _ready():
	$AnimatedSprite.playing=false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	fall(delta)
	jump()
	jumpdown() # jump of the platform (while press down togle mask bit 1 for 0.5 sec)
	walk(delta)
	move_and_slide(velocity,UP)

func _process(delta): 
	animate()
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=GRAVITY*delta
		
func jumpdown():
	if Input.is_action_pressed("ui_down") and is_on_floor():
		set_collision_mask_bit(PLATFORM,false)
		$jumptimer.start()
			
func jump():
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y=JUMP_VELOCITY
		set_collision_mask_bit(PLATFORM,false)
		$jumptimer.start()		
			
func walk(delta):
	if Input.is_action_pressed("ui_right"): # and not Input.is_action_pressed("ui_left"):
		velocity.x=SPEED
		$AnimatedSprite.flip_h=true
	elif Input.is_action_pressed("ui_left"): # and not Input.is_action_pressed("ui_right"):
		velocity.x=-SPEED
		$AnimatedSprite.flip_h=false
	else:
		if velocity.x>0:
			velocity.x-=INERTIA*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0:
			velocity.x+=INERTIA*delta
			if velocity.x>0:
				velocity.x=0
		
func animate():
	if velocity.x!=0 and is_on_floor():
		$AnimatedSprite.play("walk")		
	if velocity.x==0 and is_on_floor():
		$AnimatedSprite.play("sit")
	if velocity.y!=0 and !is_on_floor():
		$AnimatedSprite.play("Jump")
			

func _on_jumptimer_timeout():
	set_collision_mask_bit(PLATFORM,true)
	
