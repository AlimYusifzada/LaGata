#dog

extends KinematicBody2D

#const ARROW=preload("res://Enemies//arrow.tscn")
export var MINSPEED=250.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(0.9,0.9)
var velocity=Vector2()
var Speed=0.0
var Life=true
export var  JumpOffProb=0.1
onready var DogAnimation=$AnimatedSprite
onready var DeathTimer=$DeathTimer
onready var JumpTimer=$JumpTimer
onready var Voice=$Voice
onready var MindTimer=$MindTimer

#var shooting=false
var dest=velocity.x


# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	DogAnimation.speed_scale=Speed/(MINSPEED/1.5)
	DogAnimation.play("Run")
	velocity.x=Speed
	pass # Replace with function body.
	
func _physics_process(delta):
	deathcheck()
	fall(delta)
	move(delta)
	move_and_slide(velocity,Global.UP)
	#---ubpdate sund vol
	Voice.volume_db=Global.SFXVol
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && DeathTimer.is_stopped():
		body.emit_signal("Enemy")
		pass
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	LookAt()
	if !DeathTimer.is_stopped(): #play death if timer is running
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

#func jump_from_wall():
#	pass

func deathcheck():
	if !Life:
		queue_free()
		
func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food") #incease stamina
		set_collision_mask_bit(Global.GROUND,false)
		set_collision_mask_bit(Global.PLATFORM,false)
		DeathTimer.start()
		pass
	pass # Replace with function body.

func _on_DeathTimer_timeout():
	Life=false
	pass # Replace with function body.

func _on_JumpTimer_timeout():
	if randf()<0.3:
		velocity.x*=-1
	JumpTimer.stop()
	pass # Replace with function body.

func MakeVoice(body):
	if body.is_in_group("Cats"):
		Voice.play()
func ShutVoice(body):
	if body.is_in_group("Cats"):
		Voice.stop()
		
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

func _on_AimRight_body_exited(body):
	ShutVoice(body)
	pass # Replace with function body.

func _on_AimLeft_body_exited(body):
	ShutVoice(body)
	pass # Replace with function body.
