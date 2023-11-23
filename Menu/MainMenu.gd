#main menu

extends Node2D

const OptionsMenu=preload("res://Menu/Options.tscn")
onready var CatYawAnimation=$MenuPoint/CatYaw
onready var CatYawDelay=$CatYawDelay

onready var BGMusic=$BGMusic
onready var SFXSound=$SFXSound

onready var Continue=$MenuPoint/Continue
onready var transit=$"/root/Transit"

onready var crowscene1=$CrowScene1
onready var crowscene2=$CrowScene2

signal OptionsChanged

func _ready():
	crowscene1.position=Vector2(-100,randi()%400)
	crowscene2.position=Vector2(650,randi()%400)
	CatYawDelay.start(rand_range(3.0,15.0))
	Global.loadGameOptions()
	Global.loadGameState()
	show_Status()
	BGMusic.volume_db=Global.MusicVol
	BGMusic.play()
	if Global.LifesLeft<=0 || Global.Level==0:
		Continue.disabled=true
	else:
		Continue.disabled=false
	
	$MenuPoint/hint.text=Global.hint_message[randi()%Global.hint_message.size()]

func _process(delta):
	var midscr=get_parent().get_viewport().size.x/2

	$MenuPoint/Continue/LRecord.text="last record: "+str(Global.RecordPoints)
	var eye_position=get_local_mouse_position().x-midscr
	if !CatYawAnimation.playing:
		if eye_position<100:
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
	$MenuPoint/Continue/LPoints.set_text("points: "+str(Global.Points))

func _on_StartNewGame_pressed():
	Global.PlayerReset()
	transit.change_scene(Global.getLevelScene(1))
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
	$MenuPoint/hint.text=Global.hint_message[randi()%Global.hint_message.size()]
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

func _on_StartNewGame_mouse_entered():
	$MenuPoint/message.text="carefull! all progress will be lost!"
	pass # Replace with function body.

func _on_Continue_mouse_entered():
	$MenuPoint/message.text="continue the journey"
	pass # Replace with function body.

func _on_Exit_mouse_entered():
	$MenuPoint/message.text="quit from here"
	pass # Replace with function body.

func _on_Options_mouse_entered():
	$MenuPoint/message.text="game options (use ESC to call it in game)"
	pass # Replace with function body.

func _on_StartNewGame_mouse_exited():
	$MenuPoint/message.text=""
	pass # Replace with function body.

func _on_Continue_mouse_exited():
	$MenuPoint/message.text=""
	pass # Replace with function body.

func _on_Options_mouse_exited():
	$MenuPoint/message.text=""
	pass # Replace with function body.

func _on_Exit_mouse_exited():
	$MenuPoint/message.text=""
	pass # Replace with function body.
