extends KinematicBody2D

var velocity:Vector2
var Speed=500
var prev_position:Vector2
var wins
# Called when the node enters the scene tree for the first time.
func _ready():
	wins=get_parent().get_viewport().size
	pass # Replace with function body.

func _process(delta):
	prev_position=position
	move_and_collide(velocity*delta)
	if !is_on_screen():
		get_parent().emit_signal("Failed")
	if prev_position==position:
		velocity=Vector2(0,0)
		
func _input(event):
	if velocity.length()>0:
		return
	if event.is_action_pressed("ui_right"):
		velocity.x=Speed
		velocity.y=0
		pass
	elif event.is_action_pressed("ui_left"):
		velocity.x=-Speed
		velocity.y=0
		pass
	elif event.is_action_pressed("ui_down"):
		velocity.x=0
		velocity.y=Speed
		pass
	elif event.is_action_pressed("ui_up"):
		velocity.x=0
		velocity.y=-Speed
		pass
	elif event.is_action_pressed("ui_cancel"):
		get_parent().emit_signal("Failed")
		pass
	pass
	
func is_on_screen()->bool:
	if (position.x>=0 && position.x<=wins.x) && (position.y>=0 && position.y<=wins.y):
		return true
	else:
		return false
