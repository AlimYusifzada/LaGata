#cat & kitten

extends KinematicBody2D
const SPEED=350   	#walking speed
const MAXSPEED=500 	#runing speed
const JUMP_VELOCITY=-700
const KITTEN_MOD=1.5 #jumping modifiyer for kitten
const SCALE=Vector2(0.5,0.5)
const Animate_Mode="Kitten" #Cat

const DUST=preload("res://Common/JumpDust.tscn")
const FLROACH=preload("res://Player/ammo/FlyingRoach.tscn")
onready var Message=$Cam/HUD/HUDPanel/Message
onready var PlayerSprite=$AnimatedSprite
onready var JumperTimer=$jumptimer
onready var CoyoteTimer=$coyotetimer
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
onready var DblJumpTimer=$DblJumpTimer
onready var DblJumpInd=$Cam/HUD/HUDPanel/DblJumpTimerInd
onready var Bleeding=$bleeding
onready var RollingStaminaDrain=$rollingstaminadrain

enum {JUMP,SIT,WALK,RUN,ROLL}
var Animate_Name=["Jump","Sit","Walk","Run","Roll"]
var velocity=Vector2()
var Life:bool=true
var JumpPossible:bool=false
var RollPossible:bool=true
var Rolling:bool=false
var JumpCounter:int=0
var CoyoteTime:float=0.1 #0.3 is a max value for k.jump more it will be double jump
var onObject:bool=false
var canMoveWest:bool=false
var canMoveEast:bool=false
#var JoystickMove=Vector2()
var BuffTime:int=30


signal Food(stamina)
signal Die
signal Jump(power)
signal Message(message)

func _ready():
	set_scale(SCALE)
	Bleeding.set_emitting(false)
	PlayerSprite.playing=true
	JumperTimer.wait_time=0.3
	JumpCounter=Global.DblJumps
	$Tween.interpolate_property($".",
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),1,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Cam/HUD.emit_signal("UpdateHUD")
	pass
#----------------------------------------
func _physics_process(delta):
	#---FASTER---
	CoyoteTimeCheck()
	CheckDeath()
	CheckMovable(delta)
	ChecKbrdJump()
	ChecKbrdRun(delta)
	#---SLOWER---
	move_and_slide(velocity,Global.UP)#,false,4,1.0,false)
	pass

func _process(delta):
	animate()
	$Cam/HUD.emit_signal("UpdateHUD")
	pass
#----------------------------------------

func CheckMovable(delta):
	#CHAECK FALL and JUMP CONDITION
	if is_on_floor():
		velocity.y=0
		JumpPossible=true
		JumpCounter=Global.DblJumps
		if !LookDown.get_collider():
			velocity.y=Global.GRAVITY/10
	elif is_on_ceiling():
		velocity.y=1
		JumpPossible=false
	else: #in the air
		JumpPossible=JumpCounter>0
		onObject=LookDown.get_collider() || LookEDown.get_collider() || LookWDown.get_collider()
		if !onObject:#!LookDown.get_collider() && !LookEDown.get_collider() && !LookWDown.get_collider():
			velocity.y+=Global.GRAVITY*delta
		else:
			velocity.y=0
			JumpPossible=true
			JumpCounter=Global.DblJumps
	#CHECK MOVE CONDITION
	var eastobj=CheckMEast.get_collider()
	var westobj=CheckMWest.get_collider()
	canMoveEast=!(eastobj && CheckTEast.get_collider())
	canMoveWest=!(westobj && CheckTWest.get_collider())
	if eastobj:if "Tile" in eastobj.to_string():canMoveEast=false
	if westobj:if "Tile" in westobj.to_string():canMoveWest=false
	if Global.Stamina<=20:
		RollPossible=false
	else:
		RollPossible=true
	pass

func CheckDeath():
	HeartBeat.volume_db=Global.SFXVol
	if Global.Stamina<10 && !HeartBeat.playing:
		HeartBeat.play()
		emit_signal("Message","YOU CAN DIE SOON")
	elif Global.Stamina>=10:
		HeartBeat.stop()
	if Global.Stamina<=0 || velocity.y>Global.TerminateVelocity || !Life:
		set_physics_process(false)
		$Tween.start()
	pass

func ChecKbrdRun(delta):
	if Input.is_action_pressed("ui_roll") && RollPossible:
		Rolling=true
		RollingStaminaDrain.start()
	else:
		Rolling=false
	if Input.is_action_just_pressed("ui_shoot"):
		if Global.Ammo>0:
			Global.Ammo-=1
			var flroach=FLROACH.instance()
			flroach.position=position
			if PlayerSprite.is_flipped_h():
				flroach.RoachSpeed=MAXSPEED
			else:
				flroach.RoachSpeed=-MAXSPEED
			get_parent().add_child(flroach)
		else:
			Global.Ammo=0
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
			velocity.x-=MAXSPEED*delta*2
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0 && canMoveWest:
			velocity.x+=MAXSPEED*delta*2
			if velocity.x>0:
				velocity.x=0
	pass

#animation
func animate():
	if Rolling:
		PlayerSprite.play(PickAnimation(ROLL))
		PlayerSprite.rotate(10)
		set_collision_layer_bit(Global.PLAYER,false)
		set_collision_mask_bit(Global.ENEMY,false)
		set_collision_mask_bit(Global.PRAY,false)
	else:
		set_collision_layer_bit(Global.PLAYER,true)
		set_collision_mask_bit(Global.ENEMY,true)
		set_collision_mask_bit(Global.PRAY,true)
		PlayerSprite.set_rotation(0)
		if velocity.y!=0 && !(is_on_floor()||onObject): #jumping
			PlayerSprite.speed_scale=4
			PlayerSprite.play(PickAnimation(JUMP))
		if velocity.x==0 && (is_on_floor()||onObject): #idle
			PlayerSprite.speed_scale=0.1
			PlayerSprite.play(PickAnimation(SIT))
		elif abs(velocity.x)<=SPEED && (is_on_floor()||onObject): #walk
			PlayerSprite.speed_scale=2
			PlayerSprite.play(PickAnimation(WALK))
		elif abs(velocity.x)>SPEED && (is_on_floor()||onObject): #run
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
	Meow.volume_db=Global.SFXVol
	CollectSound.volume_db=Global.SFXVol
	if stamina>0:
		CollectSound.play()
	else:
		RollPossible=false
		Bleeding.set_emitting(true)
		Meow.play()
	if stamina>0:
		Global.Points+=stamina*10
	Global.Stamina+=stamina
	if Global.Stamina>100:
		Global.Stamina=100
	pass

# HUD message handling
func _on_Cat_Message(message):
	Message.text=str(message)
	MessageTimer.start(10)
	pass
func _on_messagetimer_timeout():
	Message.text=""
	pass

#jumping functions
func ChecKbrdJump():
	if Input.is_action_just_pressed("ui_up") && JumpPossible:
		if Global.Stamina>20:
			Global.Stamina-=1
		if !is_on_floor():
			EmitDust()
		jumpaction()
	elif Input.is_action_just_pressed("ui_down") && is_on_floor():
		set_collision_mask_bit(Global.PLATFORM,false)
		JumperTimer.start()
	if DblJumpTimer.is_stopped() && Global.DblJumps>1:
		DblJumpTimer.start()
	pass

func CoyoteTimeCheck():
	if !is_on_floor() && CoyoteTimer.is_stopped():
		CoyoteTimer.start(CoyoteTime)
	elif is_on_floor():
		CoyoteTimer.stop()
		JumpPossible=true

func _on_koyotetimer_timeout():
	JumpPossible=false
	pass # Replace with function body.

func _on_Cat_Jump(power): # signal
	jumpaction(power)
	EmitDust()
	pass # Replace with function body.

func _on_jumptimer_timeout():
	set_collision_mask_bit(Global.PLATFORM,true)
	pass

func jumpaction(modifier=10): #instant jump
	JumperTimer.start() # start timer to go throgh platforms
	set_collision_mask_bit(Global.PLATFORM,false)
	velocity.y=JUMP_VELOCITY-Global.Stamina-abs(velocity.x/3)-modifier
	if Global.isChild:
		velocity.y=velocity.y/KITTEN_MOD 
	JumpCounter-=1
	pass
#end of jumping
func _on_Tween_tween_all_completed():
	Global.LifesLeft-=1
	Global.PlayerAlive=false #die if trigered by highfall or stamina
	Global.saveGameState()
	queue_free()

func _on_Cat_Die():
	Bleeding.set_emitting(true)
	Meow.volume_db=Global.SFXVol
	Meow.play()
	set_collision_layer_bit(Global.PLAYER,false)
	set_collision_mask_bit(Global.PRAY,false)
	set_collision_mask_bit(Global.ENEMY,false)
	Life=false #die
	pass # Replace with function body.

func _on_DblJumpTimer_timeout():
	BuffTime-=1
	if BuffTime>0:
		DblJumpTimer.start()
	else:
		BuffTime=30
		if Global.DblJumps>1:
			Global.DblJumps-=1
			emit_signal("Message","SUPER JUMPS LEFT: %s"%(Global.DblJumps-1))
	DblJumpInd.progress=BuffTime
	pass # Replace with function body.

func _on_rollingstaminadrain_timeout():
	Global.Stamina-=10
	pass # Replace with function body.
