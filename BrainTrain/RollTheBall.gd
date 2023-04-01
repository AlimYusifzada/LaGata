extends Node2D

signal Failed
signal Success

export var DoorPath:NodePath
#onready var Door=get_node(DoorPath)

# Called when the node enters the scene tree for the first time.
func _ready():
#	if !Door:
#		print("no Door defined!")
#		queue_free()
	pass # Replace with function body.

func _on_Failed():
#	Door.emit_signal("SetClose")
	queue_free()
	pass # Replace with function body.

func _on_Success():
#	Door.emit_signal("SetOpen")
	queue_free()
	pass # Replace with function body.
