#Roach

extends KinematicBody2D

var SPEED=0
export var MINSPEED=100
export var JUMP_VELOCITY=-100
const SCALE=Vector2(0.6,0.6)
var velocity=Vector2()
var Life=true
var isRunning=true
export var JumpOffProb=0.7

onready var RoachSprite=$AnimatedSprite
onready var MindTimer=$MindTimer

signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=rand_range(MINSPEED,MINSPEED+100)
	RoachSprite.speed_scale=SPEED/(MINSPEED/2)
	set_scale(SCALE)
	RoachSprite.play("RoachRun")
	velocity.x=SPEED
	$Tween.interpolate_property($".","modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($".",
	"scale",
	$".".scale,
	$".".scale+Vector2(0.3,0.3),0.5,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func Kill():
	Life=false
	set_collision_layer_bit(Global.PRAY,false)
	$Tween.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && Life:
		body.emit_signal("Food")
		Global.MiceCatches+=1
		Kill()
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	if velocity.x>0:
		RoachSprite.flip_h=false
	else:
		RoachSprite.flip_h=true
		
func move():
	if is_on_floor() && is_on_wall():
		velocity.x*=-1
	elif !is_on_floor() && randf()>JumpOffProb && MindTimer.is_stopped():
		velocity.x*=-1
		MindTimer.start(Global.MindTimerSet)
		
func jump():
	velocity.y=-JUMP_VELOCITY
	pass

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.

func _on_Roach_Die():
	Kill()
	pass # Replace with function body.
