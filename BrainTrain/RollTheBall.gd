extends Node2D

onready var transit=$"/root/Transit"
signal Failed
signal Success
export var NextLevel=1
export var CurrentLevel=0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Failed():
	transit.change_scene(Global.getLevelScene(CurrentLevel))
	pass # Replace with function body.

func _on_Success():
	transit.change_scene((Global.getLevelScene(NextLevel)))
	pass # Replace with function body.

