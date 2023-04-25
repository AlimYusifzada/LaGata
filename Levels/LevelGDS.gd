extends Node2D

onready var transit=$"/root/Transit"

func _ready():
	if Global.getLockScene(Global.Level)=='':
		print("interscene file not found!")
	pass

func _process(delta):
	if !Global.PlayerAlive:
		transit.change_scene("res://Menu/MainMenu.tscn")

