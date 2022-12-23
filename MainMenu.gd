extends Node2D


func _ready():
	Global.loadGameState()
	if Global.LifesLeft<=0:
		$Comtinue.disabled=true
	else:
		$Comtinue.disabled=false
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
	if Global.LifesLeft>0:
		Global.PlayerAlive=true
		get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.
