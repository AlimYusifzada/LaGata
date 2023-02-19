#xenarcher

extends KinematicBody2D


const ARROW=preload("res://Enemies/arrow/arrow.tscn")
export var MINSPEED=100.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(2,2)
var velocity=Vector2()
var Speed=0.0
var Life=true
var shooting=false
var dest=velocity.x
export var JumpOffProb=0.1

signal Die

onready var JumpTimer=$JumpTimer
onready var ArcherSprite=$AnimatedSprite
onready var MindTimer=$MindTimer
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var BloodExpl=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	ArcherSprite.speed_scale=Speed/(MINSPEED/2.0)
	ArcherSprite.play("Run")
	velocity.x=Speed
	$Tween.interpolate_property($".","modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.2,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move(delta)
	move_and_slide(velocity,Global.UP)
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
		ArcherSprite.play("Death")
	elif shooting:
		ArcherSprite.play("Shoot")
	else:
		ArcherSprite.play("Run")
		
func LookAt():
	if dest>0: #face to right or left
		ArcherSprite.flip_h=false
		return 1
	else:
		ArcherSprite.flip_h=true
		return -1
		
func move(delta):
	if velocity.x!=0:
		dest=velocity.x
	elif !shooting:
		velocity.x=Speed
	jump_from_wall()

func is_wall():
	return WallOnEast.get_collider() || WallOnWest.get_collider()
	pass
func sidewall():
	if WallOnEast.get_collider():
		if velocity.x<0:
			return 1
	if WallOnWest.get_collider():
		if velocity.x>0:
			return 1
	return -1
func jump_from_wall():
	if is_on_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_on_floor() && randf()>JumpOffProb && MindTimer.is_stopped():
		MindTimer.start(Global.MindTimerSet)
		velocity.x*=-1

func Kill():
	var bl=BloodExpl.instance()
	bl.position=position
	get_parent().add_child(bl)	
	Life=false
	$Tween.start()
	
func _on_head_body_entered(body):
	if body.is_in_group("Cats") && Life:
		body.emit_signal("Food",5) #incease stamina
		Kill()
		pass
	pass # Replace with function body.

func _on_JumpTimer_timeout():
	if randf()<0.2:
		velocity.x*=-1
	JumpTimer.stop()
	pass # Replace with function body.

func _on_AimRight_body_entered(body):
	if velocity.x<0:
		velocity.x*=-1
	dest=velocity.x
	LookAt()
	Shoot()
	pass # Replace with function body.

func _on_AimLeft_body_entered(body):
	if velocity.x>0:
		velocity.x*=-1
	dest=velocity.x
	LookAt()
	Shoot()
	pass # Replace with function body.

func Shoot():
	velocity.x=0
	shooting=true
	pass
	
func _on_AnimatedSprite_animation_finished():
	if shooting:
		var arrow=ARROW.instance() #create instance of arrow
		arrow.position=position # set position
		arrow.position.y+=15
		arrow.velocity.x=LookAt()*Speed*10
		get_parent().add_child(arrow)
		shooting=false
		velocity.x=dest
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.

func _on_xenshooter_Die():
	Kill()
	pass # Replace with function body.
