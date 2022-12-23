extends Node2D


func _ready():
	Global.MiceCatches=0
	pass

func _process(delta):
	if !Global.PlayerAlive:
		get_tree().change_scene("res://MainMenu.tscn")
