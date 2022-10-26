extends KinematicBody2D


const SPEED=300
const GRAVITY=1400
const JUMP_VELOCITY=-700
const INERTIA=300
const UP=Vector2(0,-1)

var velocity=Vector2()
var Life=100
var Power=100

func _ready():
	$AnimatedSprite.play("tosit")
	$AnimatedSprite.playing=false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	fall(delta)
	jump()
	walk(delta)
	animate()
	move_and_slide(velocity,UP)
	pass
	
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=GRAVITY*delta
		
func jump():
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y=JUMP_VELOCITY
			
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
	if !is_on_floor():
		return
	if velocity.x!=0:
		$AnimatedSprite.play("walk")		
	if velocity.x==0:
		$AnimatedSprite.play("sit")
	if velocity.y!=0:
		$AnimatedSprite.play("Jump")
			

