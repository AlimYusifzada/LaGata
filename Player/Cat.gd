extends KinematicBody2D
#cat & kitten
const SPEED=350   #walking speed
const FOOD=1
const MAXSPEED=500
const JUMP_VELOCITY=-600
const KITTEN_MOD=1.2 #jumping modifiyer
const SCALE=Vector2(0.5,0.5)

var DUST=preload("res://Common/JumpDust.tscn")

enum {JUMP,SIT,WALK,RUN}
var Animate_Name=["Jump","Sit","Walk","Run"]
var Animate_Mode="Kitten"
var velocity=Vector2()
var Life=true
var animfinish=true
var JumpIsPossible=false
var KoyoteTime=0.1 #0.3 is a max value for k.jump more it will be double jump


signal Food
signal Enemy
signal Jump
signal Message(message)

func _ready():
	Global.loadGameOptions()
	$BGM.volume_db=Global.MusicVol
	$BGM.play()
	set_scale(SCALE)
	Global.Cat=self
	randomize()
	$AnimatedSprite.playing=true
	$jumptimer.wait_time=0.5
#	Global.PlayerAlive=true
	Life=true
	pass # Replace with function body.

func _physics_process(delta):
	#---FASTER---
	KoyoteTimeCheck()
	CheckDeath()
	CheckFall(delta)
	CheckJump()
	CheckRun(delta)
	#---SLOWER---
	move_and_slide(velocity,Global.UP)

	if Input.is_action_just_pressed("ui_cancel"):
		Global.saveGameState()
		Global.PlayerAlive=false
	
func _process(delta): 
	animate()
	
func KoyoteTimeCheck():
	if !is_on_floor() && $koyotetimer.is_stopped():
		$koyotetimer.start(KoyoteTime)
	elif is_on_floor():
		$koyotetimer.stop()
		JumpIsPossible=true
	
func PickAnimation(an_type=0) -> String: #pick from enum
	if Global.isChild:
		return Animate_Mode+Animate_Name[an_type]
	else:
		return Animate_Name[an_type]
	
func CheckFall(delta):
	if is_on_floor():
		velocity.y=0
	elif is_on_ceiling():
		velocity.y=2
	else:
		velocity.y+=Global.GRAVITY*delta
		
func EmitDust():		
	var dust=DUST.instance()
	get_parent().add_child(dust)
	dust.position=position

func CheckJump():
	if Input.is_action_just_pressed("ui_up") && JumpIsPossible:
		if !is_on_floor():
			EmitDust()
		if Global.Stamina>10: Global.Stamina-=0.1
		jumpaction()
	elif Input.is_action_just_pressed("ui_down") and is_on_floor():
		$jumptimer.start()
		set_collision_mask_bit(Global.PLATFORM,false)

func jumpaction(modifier=0): #instant jump
	$jumptimer.start()		
	set_collision_mask_bit(Global.PLATFORM,false)
	velocity.y=JUMP_VELOCITY-Global.Stamina*2-abs(velocity.x/3)-modifier
	if Global.isChild:
		velocity.y=velocity.y/KITTEN_MOD #makes jumps shorter for kitten

func CheckRun(delta):
	if Input.is_action_pressed("ui_runright"):#and not Input.is_action_just_pressed("ui_runright"):
		if velocity.x<MAXSPEED:
			velocity.x+=MAXSPEED*delta
		else:
			velocity.x=MAXSPEED
		$AnimatedSprite.flip_h=true #face right
	elif Input.is_action_pressed("ui_runleft"):#and not Input.is_action_just_pressed("ui_runright"):
		if velocity.x>-MAXSPEED:
			velocity.x-=MAXSPEED*delta
		else:
			velocity.x=-MAXSPEED
		$AnimatedSprite.flip_h=false #face left
	else: #inertia calc - buttons released
		if velocity.x>0:
			velocity.x-=MAXSPEED*delta
			if velocity.x<0:
				velocity.x=0
		if velocity.x<0:
			velocity.x+=MAXSPEED*delta
			if velocity.x>0:
				velocity.x=0
		
func animate(): #animation 
	if velocity.y!=0 && !is_on_floor():
		$AnimatedSprite.speed_scale=3
		$AnimatedSprite.play(PickAnimation(JUMP))
	if velocity.x==0 && is_on_floor():
		$AnimatedSprite.speed_scale=0.1
		$AnimatedSprite.play(PickAnimation(SIT))
	elif abs(velocity.x)<=SPEED && is_on_floor():
		$AnimatedSprite.speed_scale=2
		$AnimatedSprite.play(PickAnimation(WALK))
	elif abs(velocity.x)>SPEED && is_on_floor():
		$AnimatedSprite.speed_scale=3
		$AnimatedSprite.play(PickAnimation(RUN))
		
func _on_jumptimer_timeout():
		set_collision_mask_bit(Global.PLATFORM,true)

func _on_Cat_Food():
	$CollectSound.play()
	if Global.Stamina<100:
		Global.Stamina+=FOOD
		if Global.Stamina>100:
			Global.Stamina=100

func _on_Cat_Enemy():
#if enemy is meet
	Life=false #die
	pass # Replace with function body.

func CheckDeath(): 
	if Global.Stamina<=0 || velocity.y>1500 || !Life:
		Global.LifesLeft-=1
		Global.PlayerAlive=false #die if trigered by highfall or stamina
		Global.saveGameState()
		queue_free()

#message handling
func _on_Cat_Message(message):
	$Cam/HUD/HUDPanel/Message.text=str(message)
	$messagetimer.start(5)
func _on_messagetimer_timeout():
	$Cam/HUD/HUDPanel/Message.text=""

func _on_koyotetimer_timeout():
	JumpIsPossible=false
	pass # Replace with function body.

func _on_Cat_Jump(): # initiated by logic
	jumpaction(Global.Stamina*10)
	EmitDust()
	pass # Replace with function body.
