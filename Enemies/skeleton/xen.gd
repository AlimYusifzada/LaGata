#xen simple walker/skeleton

extends KinematicBody2D

export var MINSPEED=50
export var JUMP_VELOCITY=-600
const SCALE=Vector2(2,2)
var velocity=Vector2()
var Speed=0.0
var moveCounter=0
var prevX=0.0
#var Life=true
var notFalling=true
var hitting=false
var dest=velocity.x
onready var XenAnimation=$AnimatedSprite
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSouth
onready var JumpTimer=$JumpTimer
const BloodExpl=preload("res://Common/BloodExplosion/BloodExplosion.tscn")
export var JumpOffProb=0.1
onready var HitEast=$HitEast
onready var HitWest=$HitWest

signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	XenAnimation.speed_scale=Speed/(MINSPEED/2.0)
	XenAnimation.play("Run")
	velocity.x=Speed
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move()
	CheckHit()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"): # && Life:
		body.emit_signal("Food",-10)
	pass # Replace with function body.
	
func fall(delta):
	if velocity.y>Global.TerminateVelocity:
		Kill()
	if is_floor():
		velocity.y=0
		notFalling=true
	else:
		velocity.y+=Global.GRAVITY*delta
		notFalling=false

func animation():
	LookAt()
	if hitting:
		XenAnimation.play("Hit")
	elif !notFalling:
		XenAnimation.play("Jump")
	else:
		XenAnimation.play("Run")

func is_floor():
	return WallOnSouth.get_collider()
	pass
func move():
	if is_equal_approx(prevX,get_global_position().x):
		moveCounter+=1
	else:
		prevX=get_global_position().x
		moveCounter=0
	if velocity.x!=0:
		dest=velocity.x
	elif !hitting:
		velocity.x=Speed
	if is_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_floor()||moveCounter>10:
		velocity.x*=-1
		
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
	var bl=BloodExpl.instance()
	bl.position=position
	get_parent().add_child(bl)
	queue_free()

func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		if !Global.isChild:
			body.emit_signal("Food",Global.EnemyKillPrize) #incease stamina
			body.emit_signal("Jump",Global.EnemyJumpOff)
			Kill()
		pass
	pass # Replace with function body.

func _on_xen_Die():
	Kill()
	pass # Replace with function body.
	
func Jump():
	JumpTimer.start()
	set_collision_mask_bit(Global.PLATFORM,false)
	velocity.y=JUMP_VELOCITY
	pass

func _on_JumpTimer_timeout():
	set_collision_mask_bit(Global.PLATFORM,true)
	pass # Replace with function body.
	
func LookAt():
	if !notFalling: 
		XenAnimation.flip_h=false
		return 1
	if dest>0:# && notFalling: #face to right or left
		XenAnimation.flip_h=false
		return 1
	else:
		XenAnimation.flip_h=true
		return -1

func CheckHit():
	var cEast=HitEast.get_collider()
	var cWest=HitWest.get_collider()
	if cWest && !hitting:
		cWest.emit_signal("Food",-10)
	if cEast && !hitting:
		cEast.emit_signal("Food",-10)
	if (cWest || cEast):
		velocity.x=0
		hitting=true
	if (cWest && LookAt()>0) || (cEast && LookAt()<0):
		dest*=-1

func _on_AnimatedSprite_animation_finished():
	if hitting:
		hitting=false
		velocity.x=dest
	pass # Replace with function body.
