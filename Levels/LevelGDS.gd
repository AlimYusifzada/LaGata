extends Node2D

onready var transit=$"/root/Transit"

func _ready():
	if Global.getLockScene(Global.Level)=='':
		print("interscene file not found!")
	Global.loadGameOptions()
#	$BGM.volume_db=Global.MusicVol
	pass

func _process(delta):
	$BGM.volume_db=Global.MusicVol
	if !Global.PlayerAlive:
		transit.change_scene("res://Menu/MainMenu.tscn")
