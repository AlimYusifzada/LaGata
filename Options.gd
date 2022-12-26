extends Node2D


func _ready():
	Global.loadGameOptions()
	$window/MasterVol.set_value(Global.MasterVol)
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


func _on_MasterVol_value_changed(value):
	Global.MasterVol=value
	get_parent().emit_signal("OptionsChanged")
	pass # Replace with function body.


func _on_MusicVol_value_changed(value):
	Global.MusicVol=value
	get_parent().emit_signal("OptionsChanged")
	pass # Replace with function body.


func _on_SFXVol_value_changed(value):
	Global.SFXVol=value
	get_parent().emit_signal("OptionsChanged")
	pass # Replace with function body.
