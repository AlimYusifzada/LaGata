#xen human or simple skeleton no shooting
extends KinematicBody2D
export var  MINSPEED=100.0
export var JUMP_VELOCITY=-100
const SCALE=Vector2(1,1)
var velocity=Vector2()
var Speed=0.0
#var Life=true
var moveCounter=0
var prevX=0.0
var notFalling=true
signal Die

onready var XenAnimation=$AnimatedSprite
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSouth
const BloodExpl=preload("res://Common/BloodExplosion/BloodExplosion.tscn")
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
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func _on_DeathZone_body_entered(body):
	if body.is_in_group("Cats"):# && Life:
		body.emit_signal("Die")
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
	if velocity.x>0 && notFalling: #face to right or left
		XenAnimation.flip_h=false
	else:
		XenAnimation.flip_h=true
		
func is_floor():
	return WallOnSouth.is_colliding()
	pass
func is_wall():
	return WallOnEast.is_colliding() || WallOnWest.is_colliding()	
	pass
func sidewall():
	if WallOnEast.is_colliding():
		if velocity.x<0:
			return 1
	if WallOnWest.is_colliding():
		if velocity.x>0:
			return 1
	return -1
func move():
	if is_equal_approx(prevX,get_global_position().x):
		moveCounter+=1
	else:
		prevX=get_global_position().x
		moveCounter=0
	if is_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_floor()||moveCounter>10:
		velocity.x*=-1
		pass
		
func _on_CatchZone_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food",Global.EnemyKillPrize) #incease stamina
		body.emit_signal("Jump",Global.EnemyJumpOff)
		Kill()
		pass
	pass # Replace with function body.

func Kill():
	set_physics_process(false)
	$DamageZone.set_collision_mask_bit(Global.PLAYER,false)
#	Life=false
	velocity=Vector2(0,0)
	var bl=BloodExpl.instance()
	bl.position=position
	get_parent().add_child(bl)
	queue_free()
	pass

func _on_humanguy_Die():
	Kill()
	pass # Replace with function body.
