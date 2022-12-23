#dog

extends KinematicBody2D

#const ARROW=preload("res://Enemies//arrow.tscn")
const MINSPEED=250.0
const JUMP_VELOCITY=-600
const SCALE=Vector2(0.9,0.9)
var velocity=Vector2()
var Speed=0.0
var Life=true
#var shooting=false
var dest=velocity.x


# Called when the node enters the scene tree for the first time.
func _ready():
#	Global.Xen=self
	randomize()
	set_scale(SCALE)
	Speed=rand_range(MINSPEED,MINSPEED+100)
	$AnimatedSprite.speed_scale=Speed/(MINSPEED/2.0)
	$AnimatedSprite.play("Run")
	velocity.x=Speed
	pass # Replace with function body.
	
func _physics_process(delta):
	deathcheck()
	fall(delta)
	move(delta)
	move_and_slide(velocity,Global.UP)
	pass

func _process(delta):
	animation()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && $DeathTimer.is_stopped():
		body.emit_signal("Enemy")
		pass
	pass # Replace with function body.
	
func fall(delta):
	if is_on_floor():
		velocity.y=0
	else:
		velocity.y+=Global.GRAVITY*delta

func animation():
	LookAt()
	if !$DeathTimer.is_stopped(): #play death if timer is running
		$AnimatedSprite.play("Death")
#	elif shooting:
#		$AnimatedSprite.play("Shoot")
	else:
		$AnimatedSprite.play("Run")
		
func LookAt():
	if dest>0: #face to right or left
		$AnimatedSprite.flip_h=false
		return 1
	else:
		$AnimatedSprite.flip_h=true
		return -1
		
func move(delta):
	if velocity.x!=0:
		dest=velocity.x
#	elif !shooting:
#		velocity.x=Speed
	jump_from_wall()

func jump_from_wall():
	if is_on_floor() and is_on_wall():
		velocity.y=JUMP_VELOCITY #jump
		$JumpTimer.start(0.5)

func deathcheck():
	if !Life:
		queue_free()
		
func _on_head_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food") #incease stamina
		#drop sceleton down
		set_collision_mask_bit(Global.GROUND,false)
		set_collision_mask_bit(Global.PLATFORM,false)
		$DeathTimer.start()
		pass
	pass # Replace with function body.

func _on_DeathTimer_timeout():
	Life=false
	pass # Replace with function body.

func _on_JumpTimer_timeout():
	if rand_range(0.0,1.0)<0.3:
		velocity.x*=-1
	$JumpTimer.stop()
	pass # Replace with function body.


func _on_AimRight_body_entered(body):
	if velocity.x<0:
		velocity.x*=-1
	elif velocity.x==0:
		velocity.x=Speed
	LookAt()
#	Shoot()
	pass # Replace with function body.

func _on_AimLeft_body_entered(body):
	if velocity.x>0:
		velocity.x*=-1
	elif velocity.x==0:
		velocity.x=-Speed
	LookAt()
#	Shoot()
	pass # Replace with function body.

#func Shoot():
#	dest=velocity.x
#	velocity.x=0
#	shooting=true
#	pass
	
#func _on_AnimatedSprite_animation_finished():
#	if shooting:
#		var arrow=ARROW.instance() #create instance of arrow
#		arrow.position=position # set position
#		arrow.position.y+=15
#		arrow.velocity.x=LookAt(dest)*Speed*10
#		get_parent().add_child(arrow)
#		shooting=false
#		velocity.x=dest
#	pass # Replace with function body.
