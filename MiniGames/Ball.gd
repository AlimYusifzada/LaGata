extends KinematicBody2D

var velocity:Vector2
var Speed=500
var prev_position:Vector2
var move_counter=0
signal Message(msg)
onready var MessageTimer=$MessageTimer
onready var Message=$Camera2D/HUD/MessagePanel/Message
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D/HUD.HideHUD()
	if Global.TouchCtrlEnabled:
		$Camera2D/HUD.ShowCTouch()
#	$Camera2D/HUD/CtrlPanel/RightCtrl/RollBtn.visible=false
#	$Camera2D/HUD/CtrlPanel/RightCtrl/ShootBtn.visible=false
#	$Camera2D/HUD/HUDPanel/Ammo.visible=false
#	$Camera2D/HUD/HUDPanel/Keys.visible=false
#	$Camera2D/HUD/HUDPanel/CatStat.visible=false
#	$Camera2D/HUD/HUDPanel/DblJumpTimerInd.visible=false
#	$Camera2D/HUD/HUDPanel/LvlCounter.visible=false
	$Camera2D/HUD/HUDPanel/PointsCounter.text=str(Global.Points)
	emit_signal("Message","use arrow keys to move the ball in to the slot")
	if Global.Points<=0:
		emit_signal("Message","you dont have enough points to continue")
	pass # Replace with function body.

func _process(delta):
	prev_position=position
	move_and_collide(velocity*delta)
	if move_counter>100:
		get_parent().emit_signal("Failed")
	if prev_position==position:
		velocity=Vector2(0,0)
		move_counter=0
	else:
		move_counter+=1
	$Camera2D/HUD/HUDPanel/PointsCounter.text=str(Global.Points)
		
func _input(event):
	if velocity.length()>0:
		return
	if event.is_action_pressed("ui_runright") or Global.TRight:
		Global.TRight=false
		velocity.x=Speed
		velocity.y=0
		paypoints()
		pass
	elif event.is_action_pressed("ui_runleft") or Global.TLeft:
		Global.TLeft=false
		velocity.x=-Speed
		velocity.y=0
		paypoints()
		pass
	elif event.is_action_pressed("ui_down") or Global.TSlip:
		Global.TSlip=false
		velocity.x=0
		velocity.y=Speed
		paypoints()
		pass
	elif event.is_action_pressed("ui_jump") or Global.TJump:
		Global.TJump=false
		velocity.x=0
		velocity.y=-Speed
		paypoints()
		pass
	elif event.is_action_pressed("ui_cancel"):
		get_parent().emit_signal("Failed")
		pass
	pass

func paypoints(points=5):
	if Global.Points>points:
		Global.Points-=points
	else:
		Global.Points=0
		get_parent().emit_signal("Failed")
	pass

func _on_Ball_Message(msg=""):
	Message.text=msg
	MessageTimer.start(3)
	pass # Replace with function body.
func _on_MessageTimer_timeout():
	Message.text=""
	pass # Replace with function body.
