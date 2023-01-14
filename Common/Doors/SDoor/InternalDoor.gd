#internal door

extends StaticBody2D

export var DoorColor=Global.Ykey
onready var DoorAnimation=$AnimatedSprite
enum{CLOSED,OPEN}
var DoorState=CLOSED

signal SetOpen
signal SetClose
#frame 0 - open
#frame 3 - closed

func _ready():
	scale=Vector2(1,1)
	if DoorState==CLOSED:
		DoorAnimation.set_frame(3)
	else:
		DoorAnimation.set_frame(0)
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && DoorState==OPEN:
		body.emit_signal("Message","see, the door is open")
	elif body.is_in_group("Cats") && Global.KeysRing[DoorColor]>0:
		DoorAnimation.play("open")
		set_collision_mask_bit(Global.PLAYER,false)
		Global.KeysRing[DoorColor]-=1
		body.emit_signal("Message","the door is open now")
	elif body.is_in_group("Cats") && Global.KeysRing[DoorColor]<=0:
		Global.KeysRing[DoorColor]=0
		body.emit_signal("Message","the door is closed,\nyou need a key!")
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("Cats") && DoorState!=OPEN:
		DoorAnimation.play("open",true)
		set_collision_mask_bit(Global.PLAYER,true) 
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	DoorAnimation.stop()
	pass # Replace with function body.

func _on_InternalDoor_SetClose():
	set_collision_mask_bit(Global.PLAYER,true)
	DoorState=CLOSED
	DoorAnimation.set_frame(3)
	pass # Replace with function body.

func _on_InternalDoor_SetOpen():
	set_collision_mask_bit(Global.PLAYER,false)
	DoorState=OPEN
	DoorAnimation.set_frame(0)
	pass # Replace with function body.
