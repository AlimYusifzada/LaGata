#spider

extends KinematicBody2D

export var MINSPEED=100.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(1,1)
var velocity=Vector2()
var Speed=0.0
#var Life=true
#var falling=false
var prevX=0.0
var moveCounter=0
var notFalling=true
onready var SpiderAnimation=$AnimatedSprite
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSouth
const BloodExpl=preload("res://Common/BloodExplosion/BloodExplosion.tscn")
signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	SpiderAnimation.speed_scale=Speed/(MINSPEED/2.0)
	SpiderAnimation.play("Run")
	velocity.x=Speed
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func _on_DamageZone_body_entered(body):
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
		SpiderAnimation.flip_h=false
	elif velocity.x<0:
		SpiderAnimation.flip_h=true

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

func Kill():
	$DamageZone.set_collision_mask_bit(Global.PLAYER,false)
	set_physics_process(false)
	var bl=BloodExpl.instance()
	bl.position=position
	bl.cloud="brown"
	get_parent().add_child(bl)
	queue_free()

func _on_CatchZone_body_entered(body):
	if body.is_in_group("Cats"):
		if !Global.isChild:
			body.emit_signal("Food",Global.EnemyKillPrize) #incease stamina
			body.emit_signal("Jump",Global.EnemyJumpOff)
			Kill()
	pass # Replace with function body.

func _on_spider_Die():
	Kill()
	pass # Replace with function body.

