#cat & kitten

extends KinematicBody2D
const SPEED=350   	#walking speed
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
onready var Meow=$meow
onready var LookDown=$LookDown
onready var LookEDown=$LookEDown
onready var LookWDown=$LookWDown
onready var CheckMWest=$ChkMWest
onready var CheckMEast=$ChkMEast
onready var CheckTWest=$ChkTWest
onready var CheckTEast=$ChkTEast
onready var HeartBeat=$heartbeat

enum {JUMP,SIT,WALK,RUN}
var Animate_Name=["Jump","Sit","Walk","Run"]
var velocity=Vector2()
var Life=true
var JumpPossible=false
var KoyoteTime=0.1 #0.3 is a max value for k.jump more it will be double jump
var onObject=false
var canMoveWest=false
var canMoveEast=false

signal Food(stamina)
signal Die
signal Jump(power)
signal Message(message)

func _ready():
	set_scale(SCALE)
	PlayerSprite.playing=true
	JumperTimer.wait_time=0.5
	Life=true

	$Tween.interpolate_property($".",
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),1,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	
	Global.isChild=false
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
		onObject=LookDown.get_collider() || LookEDown.get_collider() || LookWDown.get_collider()
		if !onObject:#!LookDown.get_collider() && !LookEDown.get_collider() && !LookWDown.get_collider():
			velocity.y+=Global.GRAVITY*delta
		else:
			velocity.y=0
			JumpPossible=true
	#CHECK MOVE CONDITION
	canMoveEast=!(CheckMEast.get_collider() && CheckTEast.get_collider())
	canMoveWest=!(CheckMWest.get_collider() && CheckTWest.get_collider())
	pass
	
func CheckDeath():
	HeartBeat.volume_db=Global.SFXVol
	if Global.Stamina<10 && !HeartBeat.playing:
		HeartBeat.play()
	elif Global.Stamina>=10:
		HeartBeat.stop()
	if Global.Stamina<=0 || velocity.y>2000 || !Life:
		set_physics_process(false)
		$Tween.start()
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
	JumpSound.volume_db=Global.SFXVol
	JumpSound.play()
	pass
	
func _on_Cat_Food(stamina=2):
	CollectSound.volume_db=Global.SFXVol
	CollectSound.play()
	Global.Points+=stamina*50
	if Global.Stamina<100:
		Global.Stamina+=stamina
		if Global.Stamina>100:
			Global.Stamina=100
	pass
	
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
	if Input.is_action_just_pressed("ui_up") && JumpPossible:
		if !is_on_floor():
			EmitDust()
		if Global.Stamina>10: Global.Stamina-=1.0
		jumpaction()
	elif Input.is_action_just_pressed("ui_down") && is_on_floor():
		JumperTimer.start()
		set_collision_mask_bit(Global.PLATFORM,false)
	pass

func KoyoteTimeCheck():
	if !is_on_floor() && KoyoteTimer.is_stopped():
		KoyoteTimer.start(KoyoteTime)
	elif is_on_floor():
		KoyoteTimer.stop()
		JumpPossible=true

func _on_koyotetimer_timeout():
	JumpPossible=false
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
		velocity.y=velocity.y/KITTEN_MOD 
	pass
#end of jumping

func _on_Tween_tween_all_completed():
	Global.LifesLeft-=1
	Global.PlayerAlive=false #die if trigered by highfall or stamina
	Global.saveGameState()
	queue_free()

func _on_Cat_Die():
	Meow.volume_db=Global.SFXVol
	Meow.play()
	Life=false #die
	pass # Replace with function body.
