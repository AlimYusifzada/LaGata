extends Node2D

func _ready():
	pass

func _process(delta):
	if !Global.PlayerAlive:
		get_tree().change_scene("res://Menu/MainMenu.tscn")
