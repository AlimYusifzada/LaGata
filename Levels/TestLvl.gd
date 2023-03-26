extends Node2D

onready var transit=$"/root/Transit"

func _ready():
	print(Global._get_Enemies())
	pass

func _process(delta):
	if !Global.PlayerAlive:
		transit.change_scene("res://Menu/MainMenu.tscn")

