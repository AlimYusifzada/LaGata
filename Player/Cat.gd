#cat & kitten

extends KinematicBody2D
const SPEED=350   	#walking speed
const MAXSPEED=500 	#runing speed
const JUMP_VELOCITY=-700
const KITTEN_MODE=1.3 #jumping modifiyer for kitten
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
var BuffTime:int=15


signal Food(stamina)
signal Die
signal Jump(power)
signal Message(message)

func _ready():
	set_scale(SCALE)
	Bleeding.set_emitting(false)
	PlayerSprite.playing=true
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
	#CHECK FALL and JUMP CONDITION
	if is_on_floor():
		velocity.y=0
		JumpPossible=true
		JumpCounter=Global.DblJumps
		if !LookDown.get_collider():
			velocity.y=Global.GRAVITY/10
	elif is_on_ceiling():
		velocity.y=1
		JumpPossible=false
	else: #in the air or on movable object
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
	if Global.Stamina<=30:
		RollPossible=false
	else:
		RollPossible=true
	pass

func CheckDeath():
	if Global.Stamina<10 && !HeartBeat.playing:
		HeartBeat.volume_db=Global.SFXVol
		HeartBeat.play()
		emit_signal("Message","be careful")
	elif Global.Stamina>=10:
		HeartBeat.stop()
	if Global.Stamina<=0 || velocity.y>Global.TerminateVelocity || !Life:
		set_physics_process(false)
		$Tween.start()

func i_slip():
	if JumpPossible:
		set_collision_mask_bit(Global.PLATFORM,false)
		JumperTimer.start(0.2)
func i_jump():
	if JumpPossible:
		if Global.Stamina>20:
			Global.setStamina(-0.5)
		if !is_on_floor():
			EmitDust()
		jumpaction()
func i_roll():
	if RollPossible:
		Rolling=true
		RollingStaminaDrain.start()
	else:
		Rolling=false
func i_shoot():
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
func i_runright(delta):
	if canMoveEast:
		if velocity.x<MAXSPEED:
			velocity.x+=MAXSPEED*delta
		else:
			velocity.x=MAXSPEED
	PlayerSprite.flip_h=true #face right
func i_runleft(delta):
	if canMoveWest:
		if velocity.x>-MAXSPEED:
			velocity.x-=MAXSPEED*delta
		else:
			velocity.x=-MAXSPEED
	PlayerSprite.flip_h=false #face left
func i_inertia(delta):
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
func ChecKbrdRun(delta):
	if Input.is_action_just_pressed("ui_shoot"): i_shoot()
	elif Input.is_action_pressed("ui_roll"): i_roll()
	elif Input.is_action_pressed("ui_runright"): i_runright(delta)
	elif Input.is_action_pressed("ui_runleft"):	i_runleft(delta)
	else: i_inertia(delta)

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
			PlayerSprite.speed_scale=4
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

func _on_Cat_Food(stamina=1): #kill, eat or catch someting also call on non lethal hit
	if stamina>0:
		var oldVal=Global.Points
		CollectSound.volume_db=Global.SFXVol
		CollectSound.play()
		Global.Points+=stamina*10
	else:
#		RollPossible=false
		Bleeding.set_emitting(true)
		Meow.volume_db=Global.SFXVol
		Meow.play()
	Global.setStamina(stamina)
	pass

# HUD message handling
func _on_Cat_Message(message,msgtime=2):
	Message.text=str(message)
	MessageTimer.start(msgtime)
	pass
func _on_messagetimer_timeout():
	Message.text=""
	pass

#jumping functions
func ChecKbrdJump():
	if Input.is_action_just_pressed("ui_jump"):# && JumpPossible:
		i_jump()
	elif Input.is_action_just_pressed("ui_down"):# && JumpPossible:
		i_slip()
	if DblJumpTimer.is_stopped() && Global.DblJumps>1:
		DblJumpTimer.start()
	pass

func CoyoteTimeCheck():
	if !is_on_floor() && CoyoteTimer.is_stopped():
		CoyoteTimer.start(CoyoteTime)
	elif is_on_floor():
		CoyoteTimer.stop()

func _on_koyotetimer_timeout():
	JumpPossible=false
	pass # Replace with function body.
func _on_Cat_Jump(power): # unconditional jump signal
	jumpaction(power)
	EmitDust()
	pass # Replace with function body.

func _on_jumptimer_timeout():
	set_collision_mask_bit(Global.PLATFORM,true)
	pass
func jumpaction(modifier=5): #unconditional jump
	JumperTimer.start(0.5) # start timer to go throgh platforms
	set_collision_mask_bit(Global.PLATFORM,false)
	velocity.y=JUMP_VELOCITY-Global.Stamina*1.5-abs(velocity.x/3)-modifier
	if Global.isChild:
		velocity.y=velocity.y/KITTEN_MODE
	JumpCounter-=1
	pass
#end of jumping

func _on_Cat_Die():
	Bleeding.set_emitting(true)
	Meow.volume_db=Global.SFXVol
	Meow.play()
	set_collision_layer_bit(Global.PLAYER,false)
	set_collision_mask_bit(Global.PRAY,false)
	set_collision_mask_bit(Global.ENEMY,false)
	Global.isChild=true
	Life=false #die
	pass # Replace with function body.

func _on_DblJumpTimer_timeout():
	BuffTime-=1
	if BuffTime>0:
		DblJumpTimer.start()
	else:
		BuffTime=15
		if Global.DblJumps>1:
			Global.DblJumps-=1
			emit_signal("Message","kangaroo %s jump(s) left"%(Global.DblJumps-1))
	DblJumpInd.progress=BuffTime
	pass # Replace with function body.

func _on_rollingstaminadrain_timeout():
	Global.setStamina(-10)
	pass # Replace with function body.

func _on_Tween_tween_completed(object, key):
	Global.LifesLeft-=1
	Global.PlayerAlive=false #die if trigered by highfall or stamina
	Global.saveGameState()
	queue_free()
	pass # Replace with function body.

