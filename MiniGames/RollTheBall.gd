extends Node2D

onready var transit=$"/root/Transit"
signal Failed
signal Success
export var NextLevel=0
var CurrentLevel=Global.Level


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Failed():
	transit.change_scene("res://Menu/MainMenu.tscn")
	pass # Replace with function body.

func _on_Success():
	if NextLevel==0:
		#replace with final scene
		transit.change_scene("res://Menu/MainMenu.tscn")
	else:
		Global.Level=NextLevel
		Global.saveGameState()
		transit.change_scene((Global.getLevelScene(NextLevel)))
	pass # Replace with function body.

