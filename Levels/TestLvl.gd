extends Node2D

func _ready():
	print("nodes count:",get_tree().get_node_count())
	pass

func _process(delta):
	if !Global.PlayerAlive:
		get_tree().change_scene("res://Menu/MainMenu.tscn")
