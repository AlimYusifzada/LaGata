#mouse

extends KinematicBody2D

var SPEED=0
export var MINSPEED=200
export var JUMP_VELOCITY=-100
const SCALE=Vector2(0.7,0.7)
var velocity=Vector2()
var Life=true
var isRunning=true
export var JumpOffProb=0.1

onready var MouseSprite=$AnimatedSprite
onready var MindTimer=$MindTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=rand_range(MINSPEED,MINSPEED+100)
	MouseSprite.speed_scale=SPEED/(MINSPEED/3)
	set_scale(SCALE)
	MouseSprite.play("MouseRun")
	velocity.x=SPEED
	pass # Replace with function body.
	
func _physics_process(delta):
	deathcheck()
	fall(delta)
	move()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food")
		Global.MiceCatches+=1
		Life=false
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	if velocity.x>0:
		MouseSprite.flip_h=false
	else:
		MouseSprite.flip_h=true
		
func move():
	if is_on_floor() && is_on_wall():
		velocity.x*=-1
	elif !is_on_floor() && randf()>JumpOffProb && MindTimer.is_stopped():
		velocity.x*=-1
		MindTimer.start(Global.MindTimerSet)
		
func deathcheck():
	if !Life:
		queue_free()

func jump():
	velocity.y=-JUMP_VELOCITY
	pass

