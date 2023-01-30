#xen simple walker/skeleton

extends KinematicBody2D

export var MINSPEED=150
export var JUMP_VELOCITY=-600
const SCALE=Vector2(2,2)
var velocity=Vector2()
var Speed=0.0
var Life=true
onready var XenAnimation=$AnimatedSprite
onready var JumpTimer=$JumpTimer
onready var MindTimer=$MindTimer
export var JumpOffProb=0.1

signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	XenAnimation.speed_scale=Speed/(MINSPEED/2.0)
	XenAnimation.play("Run")
	velocity.x=Speed
	$Tween.interpolate_property($".","modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && Life:
		body.emit_signal("Die")
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	if !Life: #play death if timer is running
		XenAnimation.play("Death")
	elif velocity.x>0: #face to right or left
		XenAnimation.flip_h=false
	else:
		XenAnimation.flip_h=true
		
func move():
	if is_on_floor() and is_on_wall():
		velocity.y=JUMP_VELOCITY #jump
		JumpTimer.start(0.5)
	elif !is_on_floor() && randf()>JumpOffProb && MindTimer.is_stopped():
		velocity.x*=-1
		MindTimer.start(Global.MindTimerSet)
		pass
		
func Kill():
	Life=false
	set_collision_mask_bit(Global.GROUND,false)
	set_collision_mask_bit(Global.PLATFORM,false)
	$Tween.start()

func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food") #incease stamina
		Kill()
		pass
	pass # Replace with function body.

func _on_JumpTimer_timeout():
	if rand_range(0.0,1.0)<0.3:
		velocity.x*=-1
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.

func _on_xen_Die():
	Kill()
	pass # Replace with function body.
