extends Node2D

onready var SFX:AudioStreamPlayer=$SFXTest
onready var BGM:AudioStreamPlayer=$BGM
onready var musicscr=$window/TabContainer/Sound/MusicVol
onready var sfxscr=$window/TabContainer/Sound/SFXVol
onready var rev=$window/TabContainer/About/revision

func _ready():
	Global.loadGameOptions()
	rev.text="rev:"+Global.revision
	SFX.volume_db=Global.SFXVol
	BGM.volume_db=Global.MusicVol
	sfxscr.set_value(Global.SFXVol)
	musicscr.set_value(Global.MusicVol)
	position=get_viewport_rect().size/6
	pass

func _on_CancelButton_pressed():
	Global.loadGameOptions()
	get_tree().paused=false
	get_parent().emit_signal("OptionsChanged")
	queue_free()
	pass # Replace with function body.

func _on_OKButton_pressed():
	Global.saveGameOptions()
	get_tree().paused=false
	get_parent().emit_signal("OptionsChanged")
	queue_free()
	pass # Replace with function body.

func _on_MusicVol_value_changed(value):
	Global.MusicVol=value
	BGM.volume_db=value
	BGM.play()
	pass # Replace with function body.

func _on_SFXVol_value_changed(value):
	Global.SFXVol=value
	SFX.volume_db=value
	SFX.play()
	pass # Replace with function body.

func _on_MainMenuButton_pressed():
	Global.saveGameOptions()
	get_tree().paused=false
	get_tree().change_scene("res://Menu/MainMenu.tscn")
	pass # Replace with function body.
