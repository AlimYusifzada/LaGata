#cat & kitten

extends KinematicBody2D
const SPEED=350   	#walking speed
const FOOD=1 		#stamina increased by this value
const MAXSPEED=500 	#runing speed
const JUMP_VELOCITY=-600
const KITTEN_MOD=1.2 #jumping modifiyer for kitten
const SCALE=Vector2(0.5,0.5)
const Animate_Mode="Kitten"

onready var DUST=preload("res://Common/JumpDust.tscn")
onready var Message=$Cam/HUD/HUDPanel/Message
onready var PlayerSprite=$AnimatedSprite
onready var JumperTimer=$jumptimer
onready var KoyoteTimer=$koyotetimer
onready var CollectSound=$CollectSound
onready var MessageTimer=$messagetimer
onready var JumpSound=$JumpSound
onready var LookDown=$LookDown
onready var LookEDown=$LookEDown
onready var LookWDown=$LookWDown
onready var CheckMWest=$ChkMWest
onready var CheckMEast=$ChkMEast
onready var CheckTWest=$ChkTWest
onready var CheckTEast=$ChkTEast

enum {JUMP,SIT,WALK,RUN}
var Animate_Name=["Jump","Sit","Walk","Run"]
var velocity=Vector2()
var Life=true
var animfinish=true
var JumpIsPossible=false
var KoyoteTime=0.1 #0.3 is a max value for k.jump more it will be double jump
var onObject=false
var canMoveWest=false
var canMoveEast=false

signal Food
signal Enemy
signal Jump(power)
#signal OptionsChanged
signal Message(message)

func _ready():
	set_scale(SCALE)
	PlayerSprite.playing=true
	JumperTimer.wait_time=0.5
	Life=true
#	LookDown.enabled=true
	pass
#----------------------------------------
func _physics_process(delta):
	#---FASTER---
	KoyoteTimeCheck()
	CheckDeath()
	CheckMovable(delta)
	CheckJump()
	CheckRun(delta)
	#---SLOWER---
	move_and_slide(velocity,Global.UP)#,false,4,1.0,false)
	#---update sound volume
	JumpSound.volume_db=Global.SFXVol
	CollectSound.volume_db=Global.SFXVol
	pass
	
func _process(delta): 
	animate()
	pass
#-------------------------------------------

func CheckMovable(delta):
	#CHAECK FALL CONDITION
	if is_on_floor():
		velocity.y=0
	elif is_on_ceiling():
		velocity.y=2
	else: #in the air
		if !LookDown.get_collider() && !LookEDown.get_collider() && !LookWDown.get_collider():
			velocity.y+=Global.GRAVITY*delta
			onObject=false
		else:
			velocity.y=0
			JumpIsPossible=true
			onObject=true
	#CHECK MOVE CONDITION
	if CheckMEast.get_collider() && CheckTEast.get_collider():
		canMoveEast=false
	else:
		canMoveEast=true
	if CheckMWest.get_collider() && CheckTWest.get_collider():
		canMoveWest=false
	else:
		canMoveWest=true
	pass
	
func CheckDeath(): 
	if Global.Stamina<=0 || velocity.y>2000 || !Life:
		Global.LifesLeft-=1
		Global.PlayerAlive=false #die if trigered by highfall or stamina
		Global.saveGameState()
		queue_free()
	pass
	
func CheckRun(delta):
	if Input.is_action_pressed("ui_runright") && canMoveEast:#and not Input.is_action_just_pressed("ui_runright"):
		if velocity.x<MAXSPEED:
			velocity.x+=MAXSPEED*delta
		else:
			velocity.x=MAXSPEED
		PlayerSprite.flip_h=true #face right
	elif Input.is_action_pressed("ui_runleft") && canMoveWest:#and not Input.is_action_just_pressed("ui_runright"):
		if velocity.x>-MAXSPEED:
			velocity.x-=MAXSPEED*delta
		else:
			velocity.x=-MAXSPEED
		PlayerSprite.flip_h=false #face left
	else: #inertia calc - buttons released
		
		if velocity.x>0 && !canMoveEast:
			velocity.x=0
		if velocity.x<0 && !canMoveWest:
			velocity.x=0
			
		if velocity.x>0 && canMoveEast:
			velocity.x-=MAXSPEED*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0 && canMoveWest:
			velocity.x+=MAXSPEED*delta
			if velocity.x>0:
				velocity.x=0
	pass
	
#animation
func animate(): 
	if velocity.y!=0 && !(is_on_floor()||onObject):
		PlayerSprite.speed_scale=3
		PlayerSprite.play(PickAnimation(JUMP))
	if velocity.x==0 && (is_on_floor()||onObject):
		PlayerSprite.speed_scale=0.1
		PlayerSprite.play(PickAnimation(SIT))
	elif abs(velocity.x)<=SPEED && (is_on_floor()||onObject):
		PlayerSprite.speed_scale=2
		PlayerSprite.play(PickAnimation(WALK))
	elif abs(velocity.x)>SPEED && (is_on_floor()||onObject):
		PlayerSprite.speed_scale=3
		PlayerSprite.play(PickAnimation(RUN))
	pass
	
func PickAnimation(an_type=0) -> String: #pick from enum
	if Global.isChild:
		return Animate_Mode+Animate_Name[an_type]
	else:
		return Animate_Name[an_type]
	pass

func EmitDust():		
	var dust=DUST.instance()
	get_parent().add_child(dust)
	dust.position=position
	JumpSound.play()
	pass
	
func _on_Cat_Food():
	CollectSound.volume_db=Global.SFXVol
	CollectSound.play()
	if Global.Stamina<100:
		Global.Stamina+=FOOD
		if Global.Stamina>100:
			Global.Stamina=100
	pass
	
func _on_Cat_Enemy():
	# if enemy is meet
	# call death screen
	Life=false #die
	pass # Replace with function body.

# HUD message handling
func _on_Cat_Message(message):
	Message.text=str(message)
	MessageTimer.start(5)
	pass
func _on_messagetimer_timeout():
	Message.text=""
	pass

#jumping
func CheckJump():
	if Input.is_action_just_pressed("ui_up") && JumpIsPossible:
		if !is_on_floor():
			EmitDust()
		if Global.Stamina>10: Global.Stamina-=0.1
		jumpaction()
	elif Input.is_action_just_pressed("ui_down") and is_on_floor():
		JumperTimer.start()
		set_collision_mask_bit(Global.PLATFORM,false)
	pass	

func KoyoteTimeCheck():
	if !is_on_floor() && KoyoteTimer.is_stopped():
		KoyoteTimer.start(KoyoteTime)
	elif is_on_floor():
		KoyoteTimer.stop()
		JumpIsPossible=true

func _on_koyotetimer_timeout():
	JumpIsPossible=false
	pass # Replace with function body.

func _on_Cat_Jump(power): # initiated by logic
	jumpaction(Global.Stamina*power)
	EmitDust()
	pass # Replace with function body.

func _on_jumptimer_timeout():
	set_collision_mask_bit(Global.PLATFORM,true)
	pass

func jumpaction(modifier=0): #instant jump
	JumperTimer.start()		
	set_collision_mask_bit(Global.PLATFORM,false)
	velocity.y=JUMP_VELOCITY-Global.Stamina*2-abs(velocity.x/3)-modifier
	if Global.isChild:
		#makes jumps shorter for kitten
		velocity.y=velocity.y/KITTEN_MOD 
	pass
#end of jumping
