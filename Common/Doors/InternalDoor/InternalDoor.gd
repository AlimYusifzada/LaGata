#internal door

extends StaticBody2D

export var DoorColor=Global.Ykey
onready var DoorAnimation=$AnimatedSprite
onready var DoorSound=$AudioStreamPlayer2D
enum{CLOSED,OPEN}
var DoorState=CLOSED

signal SetOpen
signal SetClose
#frame 0 - open
#frame 3 - closed
export var NextDoorPath:NodePath
var NextDoor:Node#=get_node(NextDoorPath)

func _ready():
	if NextDoorPath=='':
		NextDoor=null
	else:
		NextDoor=get_node(NextDoorPath) #or message
		
	scale=Vector2(1,1)
	if DoorState==CLOSED:
		DoorAnimation.set_frame(3)
	else:
		DoorAnimation.set_frame(0)
	pass
	
#func _process(delta):
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && DoorState==OPEN:
		SetDoor(false)
		DoorAnimation.play("open")
		DoorSound.play()
	elif body.is_in_group("Cats") && Global.KeysRing[DoorColor]>0 && DoorState==CLOSED:
		SetDoor(false)
		Global.KeysRing[DoorColor]-=1
		DoorState=OPEN
		DoorAnimation.play("open")
		DoorSound.play()
	elif body.is_in_group("Cats") && Global.KeysRing[DoorColor]<=0 && DoorState==CLOSED:
		Global.KeysRing[DoorColor]=0
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("Cats") && DoorState!=OPEN:
		DoorAnimation.play("open",true)
		DoorSound.play()
		SetDoor(true)
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	DoorAnimation.stop()
	pass # Replace with function body.

func _on_InternalDoor_SetClose():
	SetDoor(true)
	DoorState=CLOSED
	DoorAnimation.set_frame(3)
	pass # Replace with function body.

func _on_InternalDoor_SetOpen():
	SetDoor(false)
	DoorState=OPEN
	DoorAnimation.set_frame(0)
	pass # Replace with function body.

func SetDoor(status):
	if status:
		if NextDoor:
			NextDoor.emit_signal("SetClose")
	else:
		if NextDoor:
			NextDoor.emit_signal("SetOpen")
	set_collision_layer_bit(Global.GROUND,status)
	set_collision_mask_bit(Global.PLAYER,status)
	set_collision_mask_bit(Global.PRAY,status)
	set_collision_mask_bit(Global.ENEMY,status)
