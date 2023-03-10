#slime simple walker

extends KinematicBody2D

export var MINSPEED=10
export var JUMP_VELOCITY=-600
const SCALE=Vector2(1,1)
var velocity=Vector2()
var Speed=0.0
onready var XenAnimation=$AnimatedSprite
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSouth
export var JumpOffProb=0.1
const BloodExplosion=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")
signal Die
# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	XenAnimation.speed_scale=Speed/(MINSPEED/1.5)
	XenAnimation.play("Run")
	velocity.x=Speed
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	#animation() # no animation yet
	pass

func _on_DamageZone_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Die")
	pass # Replace with function body.
	
func fall(delta):
	if velocity.y>Global.TerminateVelocity:
		Kill()
	if is_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

#func animation():
#	if velocity.x>0: #face to right or left
#		XenAnimation.flip_h=false
#	else:
#		XenAnimation.flip_h=true
		
func move():
	if is_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_floor():# && randf()>JumpOffProb && MindTimer.is_stopped():
		velocity.x*=-1
		pass
func is_floor():
	return WallOnSouth.get_collider()
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
func Kill():
	set_physics_process(false)
	$DamageZone.set_collision_mask_bit(Global.PLAYER,false)
	var bl=BloodExplosion.instance()
	bl.position=position
	bl.cloud="acid"
	bl.scale=Vector2(2,2)
	get_parent().add_child(bl)
	queue_free()
	pass

func _on_oranjeslime_Die():
	Kill()
	pass # Replace with function body.
