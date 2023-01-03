extends Node2D

onready var SFX=$SFXTest
onready var BGM=$BGM


func _ready():
	Global.loadGameOptions()
	$window/SFXVol.set_value(Global.SFXVol)
	$window/MusicVol.set_value(Global.MusicVol)
	position=get_viewport_rect().size/6
	pass

func _on_CancelButton_pressed():
	get_tree().paused=false
	Global.loadGameOptions()
	get_parent().emit_signal("OptionsChanged")
	queue_free()
	pass # Replace with function body.

func _on_OKButton_pressed():
	get_tree().paused=false
	Global.saveGameOptions()
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
