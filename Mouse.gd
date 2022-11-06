extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED=100
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
	move_and_slide(velocity,UP)
	pass

func _on_Area2D_body_entered(body):
	print(body)
	pass # Replace with function body.
