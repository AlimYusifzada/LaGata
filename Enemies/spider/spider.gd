#spider

extends KinematicBody2D

export var MINSPEED=100.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(1,1)
var velocity=Vector2()
var Speed=0.0
var Life=true
export var JumpOffProb=0.5
onready var SpiderAnimation=$AnimatedSprite
onready var JumpTimer=$JumpTimer
onready var MindTimer=$MindTimer
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var BloodExpl=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")
signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	SpiderAnimation.speed_scale=Speed/(MINSPEED/2.0)
	SpiderAnimation.play("Run")
	velocity.x=Speed
	$Tween.interpolate_property($".","modulate",
		Color(1,1,1,1),Color(1,1,1,0),0.2,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
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
	if velocity.x>0: #face to right or left
		SpiderAnimation.flip_h=false
	elif velocity.x<0:
		SpiderAnimation.flip_h=true


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
		
func move():
	if is_on_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_on_floor() && randf()>JumpOffProb && MindTimer.is_stopped():
		velocity.x*=-1
		MindTimer.start(Global.MindTimerSet)
		pass

func Kill():
	var bl=BloodExpl.instance()
	bl.position=position
	bl.cloud="acid"
	get_parent().add_child(bl)
	Life=false
	set_collision_layer_bit(Global.ENEMY,false)
	$Tween.start()

func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food",4) #incease stamina
		Kill()
		pass
	pass # Replace with function body.

func _on_JumpTimer_timeout():
	if randf()<0.3:
		velocity.x*=-1
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.

func _on_spider_Die():
	Kill()
	pass # Replace with function body.

