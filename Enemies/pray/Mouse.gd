#mouse

extends KinematicBody2D

var SPEED=0
export var MINSPEED=200
export var JUMP_VELOCITY=-100
const SCALE=Vector2(0.7,0.7)
var velocity=Vector2()
var Life=true
var isRunning=true
var moveCounter=0
var prevX=0.0

onready var MouseSprite=$AnimatedSprite
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSouth
onready var BloodExpl=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")

signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=rand_range(MINSPEED,MINSPEED+100)
	MouseSprite.speed_scale=SPEED/(MINSPEED/3)
	set_scale(SCALE)
	MouseSprite.play("MouseRun")
	velocity.x=SPEED
	pass # Replace with function body.

func _physics_process(delta):
	fall(delta)
	move()
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func Kill():
	Life=false
	set_collision_layer_bit(Global.PRAY,false)
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && Life:
		body.emit_signal("Food",-3)
		velocity.x*=-1
#		Kill()
	pass # Replace with function body.

func _on_CatchZone_body_entered(body):
	if body.is_in_group("Cats") && Life:
		Global.MiceCatches+=1
		body.emit_signal("Food",5)
		var bl=BloodExpl.instance()
		bl.position=position
		get_parent().add_child(bl)
		Kill()	
	pass # Replace with function body.

func fall(delta):
	if is_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	if velocity.x>0:
		MouseSprite.flip_h=false
	else:
		MouseSprite.flip_h=true
func is_floor():
	return WallOnSouth.get_collider()
	pass
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
	if is_equal_approx(prevX,get_global_position().x):
		moveCounter+=1
	else:
		prevX=get_global_position().x
		moveCounter=0
	if is_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_floor()||moveCounter>10:
		velocity.x*=-1

func _on_Mouse_Die():
	Kill()
	pass # Replace with function body.
