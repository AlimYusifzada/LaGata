extends Node2D

onready var transit=$"/root/Transit"
signal Failed
signal Success
export var NextLevel=1
var CurrentLevel=Global.Level


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Failed():
	transit.change_scene(Global.getLevelScene(Global.Level))
	pass # Replace with function body.

func _on_Success():
	if NextLevel==0:
		transit.change_scene("res://Menu/MainMenu.tscn")
	else:
		Global.Level=NextLevel
		Global.saveGameState()
		transit.change_scene((Global.getLevelScene(NextLevel)))
	pass # Replace with function body.

