extends AnimatedSprite

export var DoorTrapPath:NodePath
export var TriggerGroup:String="Movable" #Pray or Cats or Enemy
export var Latch=false
onready var DoorTrap=get_node(DoorTrapPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	play("released")
	if !DoorTrap:
		print("the door is not defined")
		queue_free()
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.is_in_group(TriggerGroup) && DoorTrap:
		DoorTrap.emit_signal("SetOpen")
		play("pressed")
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group(TriggerGroup) && DoorTrap && !Latch:
		DoorTrap.emit_signal("SetClose")
		play("released")
	pass # Replace with function body.
