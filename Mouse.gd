extends KinematicBody2D

const SPEED=100
const FALLSPEED = 700
const GRAVITY = 1500
const UP=Vector2(0,-1)
const LIFEDAMAGE=-100
const JUMP_VELOCITY=-1000
var velocity=Vector2()
var Life=100

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Run")
	velocity.x=SPEED
	pass # Replace with function body.
	
func _physics_process(delta):
	deathcheck()
	fall(delta)
	move(delta)
	move_and_slide(velocity,UP)
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food")
		Life+=LIFEDAMAGE
	if body.is_in_group("Edge"):
		velocity.x*=-1
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
		
func deathcheck():
	if Life<=0:
		queue_free()
		
func jump():
	if is_on_floor():
		velocity.y=-JUMP_VELOCITY
	pass
	
