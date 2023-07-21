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
	#replace with failed screen
	transit.change_scene("res://Menu/MainMenu.tscn")
	pass # Replace with function body.

func _on_Success():
	if NextLevel==0:
		#replace with final scene
		transit.change_scene("res://Menu/MainMenu.tscn")
	else:
		# move to the next level
		Global.Level=NextLevel
		Global.saveGameState()
		var nl=Global.getLevelScene(NextLevel)
		if nl.length()>0:
			transit.change_scene(nl)
		else:
			transit.change_scene("res://Menu/MainMenu.tscn")
	pass # Replace with function body.

