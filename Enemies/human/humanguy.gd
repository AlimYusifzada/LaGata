#xen human or simple skeleton no shooting
extends KinematicBody2D
export var  MINSPEED=100.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(1,1)
var velocity=Vector2()
var Speed=0.0
var Life=true
export var JumpOffProb=0.1

onready var XenAnimation=$AnimatedSprite
onready var DeathTimer=$DeathTimer
onready var JumpTimer=$JumpTimer
onready var MindTimer=$MindTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	XenAnimation.speed_scale=Speed/(MINSPEED/2.0)
	XenAnimation.play("Run")
	velocity.x=Speed
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
	if body.is_in_group("Cats") && DeathTimer.is_stopped():
		body.emit_signal("Enemy")
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	if !DeathTimer.is_stopped(): #play death if timer is running
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
		
func deathcheck():
	if !Life:
		queue_free()
		
func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food") #incease stamina
		#drop sceleton down
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
	pass # Replace with function body.

