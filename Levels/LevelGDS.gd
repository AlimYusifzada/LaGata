extends Node2D

onready var transit=$"/root/Transit"
const width=1920
const height=1080 
func _ready():
#	Global.PlayerReset()
	if Global.getLockScene(Global.Level)=='':
		print("lock interscene not found")
	pass

func _process(delta):
	if !Global.PlayerAlive:
		transit.change_scene("res://Menu/MainMenu.tscn")

