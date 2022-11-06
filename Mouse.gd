extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED=300
const FALLSPEED = 700
const GRAVITY = 1500
const UP=Vector2(0,-1)
var velocity=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Run")
	velocity.x=SPEED
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move(delta)
	move_and_slide(velocity,UP)
	pass

func _process(delta):
	animation()
	

func _on_Area2D_body_entered(body):
	print(body)
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=GRAVITY*delta

func animation():
	if velocity.x>0:
		$AnimatedSprite.flip_h=false
	else:
		$AnimatedSprite.flip_h=true
		
func move(delta):
	if is_on_floor() and is_on_wall():
		velocity.x*=-1
		
	pass
