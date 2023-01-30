#dog

extends KinematicBody2D

#const ARROW=preload("res://Enemies//arrow.tscn")
export var MINSPEED=200.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(0.8,0.8)
var velocity=Vector2()
var Speed=0.0
var Life=true
export var  JumpOffProb=0.1
onready var DogAnimation=$AnimatedSprite
onready var JumpTimer=$JumpTimer
onready var Voice=$Voice
onready var MindTimer=$MindTimer

signal Die

#var shooting=false
var dest=velocity.x


# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	DogAnimation.speed_scale=Speed/(MINSPEED/1.5)
	DogAnimation.play("Run")
	velocity.x=Speed
	$Tween.interpolate_property($".","modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.5,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move(delta)
	move_and_slide(velocity,Global.UP)
	#---ubpdate sund vol
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && Life:
		body.emit_signal("Die")
		pass
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	LookAt()
	if !Life: #play death if timer is running
		DogAnimation.play("Death")
	else:
		DogAnimation.play("Run")
		
func LookAt():
	if velocity.x>0: #face to right or left
		DogAnimation.flip_h=false
		return 1
	else:
		DogAnimation.flip_h=true
		return -1
		
func move(delta):
	if is_on_floor() && is_on_wall():
		velocity.y=JUMP_VELOCITY #jump
		JumpTimer.start(0.5)
	elif !is_on_floor() && (MindTimer.is_stopped() && randf()>JumpOffProb):
		velocity.x*=-1.0
		MindTimer.start(Global.MindTimerSet)

func Kill():
	set_collision_mask_bit(Global.GROUND,false)
	set_collision_mask_bit(Global.PLATFORM,false)
	Life=false
	$Tween.start()
	
func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food") #incease stamina
		Kill()
	pass # Replace with function body.

func _on_JumpTimer_timeout():
	if randf()<0.3:
		velocity.x*=-1
	JumpTimer.stop()
	pass # Replace with function body.

func MakeVoice(body):
	if body.is_in_group("Cats"):
		Voice.volume_db=Global.SFXVol
		Voice.play()
		
func _on_AimRight_body_entered(body):
	MakeVoice(body)
	if velocity.x<0:
		velocity.x*=-1
	elif velocity.x==0:
		velocity.x=Speed
	LookAt()
	pass # Replace with function body.

func _on_AimLeft_body_entered(body):
	MakeVoice(body)
	if velocity.x>0:
		velocity.x*=-1
	elif velocity.x==0:
		velocity.x=-Speed
	LookAt()
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.


func _on_dog_Die():
	Kill()
	pass # Replace with function body.
