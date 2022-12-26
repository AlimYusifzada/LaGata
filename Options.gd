extends Node2D


func _ready():
	Global.loadGameOptions()
	$window/SFXVol.set_value(Global.SFXVol)
	$window/MusicVol.set_value(Global.MusicVol)
	pass

func _on_CancelButton_pressed():
	Global.loadGameOptions()
	get_parent().emit_signal("OptionsChanged")
	queue_free()
	pass # Replace with function body.

func _on_OKButton_pressed():
	Global.saveGameOptions()
	queue_free()
	pass # Replace with function body.

func _on_MusicVol_value_changed(value):
	Global.MusicVol=value
	get_parent().emit_signal("OptionsChanged")
	pass # Replace with function body.

func _on_SFXVol_value_changed(value):
	Global.SFXVol=value
	$SFXTest.volume_db=value
	$SFXTest.play()
	get_parent().emit_signal("OptionsChanged")
	pass # Replace with function body.
