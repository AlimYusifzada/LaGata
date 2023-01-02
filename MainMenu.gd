#main menu

extends Node2D

onready var OptionsMenu=preload("res://Options.tscn")
onready var CatYawAnimation=$CatYaw
onready var CatYawDelay=$CatYawDelay
onready var BGMusic=$BGMusic
onready var Comtinue=$Comtinue
signal OptionsChanged

func _ready():
	randomize()
	CatYawDelay.start(rand_range(3.0,15.0))
	Global.loadGameOptions()
	Global.loadGameState()
	BGMusic.volume_db=Global.MusicVol
	BGMusic.play()
	if Global.LifesLeft<=0:
		Comtinue.disabled=true
	else:
		Comtinue.disabled=false
	pass
	
func _process(delta):
	var eye_position=get_global_mouse_position()-CatYawAnimation.position
	if !CatYawAnimation.playing:
		if eye_position.x<-100:
			CatYawAnimation.play("lookright")
			pass
		elif eye_position.x>100:
			CatYawAnimation.play("lookleft")
			pass
		else:
			CatYawAnimation.play("default")
			pass
		CatYawAnimation.stop()
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

func _on_CatYawDelay_timeout():
	CatYawAnimation.play("yaw")
	pass # Replace with function body.

func _on_CatYaw_animation_finished():
	CatYawAnimation.stop()
	CatYawDelay.start(rand_range(3.0,15.0))
	pass # Replace with function body.


func _on_Options_pressed():
	var om=OptionsMenu.instance()
	om.position=Vector2(220,150)
	self.add_child(om)
	pass # Replace with function body.

func _on_MainMenu_OptionsChanged():
	BGMusic.volume_db=Global.MusicVol
	pass # Replace with function body.
