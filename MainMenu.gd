extends Node2D


func _ready():
	pass

func _on_StartNewGame_pressed():
	Global.PlayerReset()
	get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.

func _on_Exit_pressed():
	Global.saveGameState()
	get_tree().quit(0)
	pass # Replace with function body.

func _on_Comtinue_pressed():
	Global.loadGameState()
	Global.PlayerAlive=true
	get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.
