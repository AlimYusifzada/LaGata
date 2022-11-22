extends KinematicBody2D

var SPEED=0
const MINSPEED=150
const FALLSPEED = 700
const GRAVITY = 1500
const UP=Vector2(0,-1)
const JUMP_VELOCITY=-1000
const SCALE=Vector2(0.7,0.7)
var velocity=Vector2()
var Life=true


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Mouse=self
	randomize()
	SPEED=rand_range(MINSPEED,MINSPEED+100)
	$AnimatedSprite.speed_scale=SPEED/(MINSPEED/3)
	set_scale(SCALE)
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
		Life=false
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
	if !Life:
		queue_free()
		
func jump():
	if is_on_floor():
		velocity.y=-JUMP_VELOCITY
	pass
	
