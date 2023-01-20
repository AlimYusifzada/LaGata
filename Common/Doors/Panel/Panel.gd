extends AnimatedSprite

export var DoorName="DoorName"
onready var Door=get_parent().get_node(DoorName)

# Called when the node enters the scene tree for the first time.
func _ready():
	play("released")
	if Door==null:
		print("the door is not defined")
		queue_free()
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.is_in_group("Movable") && Door:
		Door.emit_signal("SetOpen")
		play("pressed")
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("Movable") && Door:
		Door.emit_signal("SetClose")
		play("released")
	pass # Replace with function body.
