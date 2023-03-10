#dog

extends KinematicBody2D

export var MINSPEED=200.0
export var JUMP_VELOCITY=-600
const SCALE=Vector2(0.8,0.8)
var velocity=Vector2()
var Speed=0.0
var Life=true
var moveCounter=0
var prevX=0.0
onready var DogAnimation=$AnimatedSprite
onready var Voice=$Voice
onready var WallOnWest=$RayCastWest
onready var WallOnEast=$RayCastEast
onready var WallOnSouth=$RayCastSuth
onready var BloodExpl=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")
signal Die


# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	DogAnimation.speed_scale=Speed/(MINSPEED/2)
	DogAnimation.play("Run")
	velocity.x=Speed
	pass # Replace with function body.
	
func _physics_process(delta):
	fall(delta)
	move(delta)
	move_and_slide(velocity,Global.UP)
	#---ubpdate sund vol
	pass

func _process(delta):
	animation()

func fall(delta):
	if velocity.y>Global.TerminateVelocity:
		Kill()
	if is_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	LookAt()
	if !Life: #play death if timer is running
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
func move(delta):
	if is_equal_approx(prevX,get_global_position().x):
		moveCounter+=1
	else:
		prevX=get_global_position().x
		moveCounter=0
	if is_floor() && is_wall():
		velocity.x*=sidewall()
	elif !is_floor()||moveCounter>10:
		velocity.x*=-1.0

func Kill():
	set_physics_process(false)
	$DamageZone.set_collision_mask_bit(Global.PLAYER,false)
	var bl=BloodExpl.instance()
	bl.position=position
	get_parent().add_child(bl)
	Life=false
	queue_free()
	
func _on_CatchZone_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food",10) #incease stamina
		body.emit_signal("Jump",5)
		Kill()
	pass # Replace with function body.

func MakeVoice(body):
	if body.is_in_group("Cats"):
		Voice.volume_db=Global.SFXVol
		Voice.play()
		
func _on_AimRight_body_entered(body):
	Speed+=50
	MakeVoice(body)
	if velocity.x<0:
		velocity.x*=-1
	elif velocity.x==0:
		velocity.x=Speed
	LookAt()
	pass # Replace with function body.

func _on_AimLeft_body_entered(body):
	Speed+=50
	MakeVoice(body)
	if velocity.x>0:
		velocity.x*=-1
	elif velocity.x==0:
		velocity.x=-Speed
	LookAt()
	pass # Replace with function body.

func _on_dog_Die():
	Kill()
	pass # Replace with function body.
	
func _on_DamageZone_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Die") #incease stamina
	pass # Replace with function body.

func _on_Aim_body_exited(body):
	Speed-=50
	pass # Replace with function body.
