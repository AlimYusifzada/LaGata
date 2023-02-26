#Roach

extends KinematicBody2D

var SPEED=0
export var MINSPEED=100
export var JUMP_VELOCITY=-100
const SCALE=Vector2(0.6,0.6)
var velocity=Vector2()
var Life=true
var isRunning=true
export var JumpOffProb=0.7

onready var RoachSprite=$AnimatedSprite
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSouth
onready var BloodExpl=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")
signal Die

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=rand_range(MINSPEED,MINSPEED+100)
	RoachSprite.speed_scale=SPEED/(MINSPEED/2)
	set_scale(SCALE)
	RoachSprite.play("RoachRun")
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
	$DamageZone.set_collision_layer_bit(Global.PRAY,false)
	$DamageZone.set_collision_mask_bit(Global.PLAYER,false)
	velocity=Vector2(0,0)
	var bl=BloodExpl.instance()
	bl.position=position
	bl.cloud="brown"
	get_parent().add_child(bl)
	queue_free()

func _on_DamageZone_body_entered(body):
	if body.is_in_group("Cats") && Life:
		body.emit_signal("Food",-2)
		Kill()
	pass # Replace with function body.

func _on_CatchZone_body_entered(body):
	if body.is_in_group("Cats") && Life:
		Global.MiceCatches+=1
		body.emit_signal("Food",2)
		Kill()
	pass # Replace with function body.

func fall(delta):
	if is_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	if velocity.x>0:
		RoachSprite.flip_h=false
	else:
		RoachSprite.flip_h=true
		
func is_floor():
	return WallOnSouth.get_collider()
func is_wall():
	return WallOnEast.get_collider() || WallOnWest.get_collider()
func sidewall():
	if WallOnEast.get_collider():
		if velocity.x<0:
			return 1
	if WallOnWest.get_collider():
		if velocity.x>0:
			return 1
	return -1
func move():
	if is_floor() && is_wall():
		velocity.x*=sidewall()

func _on_Roach_Die():
	Kill()
	pass # Replace with function body.
