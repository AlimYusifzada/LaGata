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
	fall(delta)
	move()
	move_and_slide(velocity,UP)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func move():
	pass

func fall(delta):
	if is_on_floor():
		velocity.y=0
	else: 
		velocity.y+=FALLSPEED*delta
	pass
