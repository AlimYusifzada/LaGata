#main menu

extends Node2D

const OptionsMenu=preload("res://Menu/Options.tscn")
onready var CatYawAnimation=$MenuPoint/CatYaw
onready var CatYawDelay=$CatYawDelay
onready var BGMusic=$BGMusic
onready var Continue=$MenuPoint/Continue
onready var SFXSound=$SFXSound
onready var MenuPoint=$MenuPoint
onready var transit=$"/root/Transit"
export var StartLevel="res://Levels/level0.tscn"

signal OptionsChanged

func _ready():
	CatYawDelay.start(rand_range(3.0,15.0))
	Global.loadGameOptions()
	Global.loadGameState()
	show_Status()
	BGMusic.volume_db=Global.MusicVol
	BGMusic.play()
	if Global.LifesLeft<=0:
		Continue.disabled=true
	else:
		Continue.disabled=false
	pass

func _process(delta):
	var eye_position=get_global_mouse_position().x-CatYawAnimation.position.x
	if !CatYawAnimation.playing:
		if eye_position<-100:
			CatYawAnimation.play("lookright")
			pass
		elif eye_position>100:
			CatYawAnimation.play("lookleft")
			pass
		else:
			CatYawAnimation.play("default")
			pass
		CatYawAnimation.stop()
	pass

func show_Status():
	$MenuPoint/Continue/LLevel.set_text("level: "+str(Global.Level))
	$MenuPoint/Continue/LLife.set_text("lifes left: "+str(Global.LifesLeft))
	$MenuPoint/Continue/LStamina.set_text("stamina: "+str(Global.Stamina))

func _on_StartNewGame_pressed():
	Global.PlayerReset()
	transit.change_scene(StartLevel)
	pass # Replace with function body.

func _on_Exit_pressed():
	Global.saveGameOptions()
	Global.saveGameState()
	get_tree().quit(0)
	pass # Replace with function body.

func _on_Continue_pressed():
	Global.loadGameOptions()
	Global.loadGameState()
	if Global.LifesLeft>0:
		Global.PlayerAlive=true
		transit.change_scene(Global.getLevelScene(Global.Level))
	pass # Replace with function body.

func _on_CatYawDelay_timeout():
	CatYawAnimation.play("yaw")
	pass # Replace with function body.

func _on_CatYaw_animation_finished():
	CatYawAnimation.stop()
	CatYawDelay.start(rand_range(3.0,15.0))
	pass # Replace with function body.

func _on_Options_pressed():
	get_tree().paused=true
	var om=OptionsMenu.instance()
	self.add_child(om)
	pass # Replace with function body.

func _on_MainMenu_OptionsChanged():
	Global.loadGameOptions()
	SFXSound.volume_db=Global.SFXVol
	BGMusic.volume_db=Global.MusicVol
	pass # Replace with function body.
