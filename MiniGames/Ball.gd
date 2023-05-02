extends KinematicBody2D

var velocity:Vector2
var Speed=500
var prev_position:Vector2
var wins

signal Message(msg)
onready var MessageTimer=$MessageTimer
onready var Message=$Camera2D/HUD/HUDPanel/Message
# Called when the node enters the scene tree for the first time.
func _ready():
	wins=get_parent().get_viewport().size
	$Camera2D/HUD/HUDPanel/Ammo.visible=false
	$Camera2D/HUD/HUDPanel/Keys.visible=false
	$Camera2D/HUD/HUDPanel/CatStat.visible=false
	$Camera2D/HUD/HUDPanel/DblJumpTimerInd.visible=false
	$Camera2D/HUD/HUDPanel/LvlCounter.visible=false
	$Camera2D/HUD/HUDPanel/PointsCounter.text=str(Global.Points)
	emit_signal("Message","use arrow keys to move the ball in to the slot")
	if Global.Points<=0:
		emit_signal("Message","you dont have enough points to continue")
	pass # Replace with function body.

func _process(delta):
	prev_position=position
	move_and_collide(velocity*delta)
	if !is_on_screen():
		get_parent().emit_signal("Failed")
	if prev_position==position:
		velocity=Vector2(0,0)
	$Camera2D/HUD/HUDPanel/PointsCounter.text=str(Global.Points)
		
func _input(event):
	if velocity.length()>0:
		return
	if event.is_action_pressed("ui_runright"):
		velocity.x=Speed
		velocity.y=0
		paypoints()
		pass
	elif event.is_action_pressed("ui_runleft"):
		velocity.x=-Speed
		velocity.y=0
		paypoints()
		pass
	elif event.is_action_pressed("ui_down"):
		velocity.x=0
		velocity.y=Speed
		paypoints()
		pass
	elif event.is_action_pressed("ui_jump"):
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

func is_on_screen()->bool:
	if (position.x>=0 && position.x<=wins.x) && (position.y>=0 && position.y<=wins.y):
		return true
	else:
		return false
		
func _on_Ball_Message(msg=""):
	Message.text=msg
	MessageTimer.start(3)
	pass # Replace with function body.
func _on_MessageTimer_timeout():
	Message.text=""
	pass # Replace with function body.
