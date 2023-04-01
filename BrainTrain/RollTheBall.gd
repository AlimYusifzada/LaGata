extends Node2D

signal Failed
signal Success

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Node2D_Failed():
	print("Failed")
	queue_free()
	pass # Replace with function body.

func _on_lock_Success():
	print("Success")
	queue_free()
	pass # Replace with function body.
