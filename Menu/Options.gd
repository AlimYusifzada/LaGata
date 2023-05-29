extends Node2D

onready var SFX:AudioStreamPlayer=$SFXTest
onready var BGM:AudioStreamPlayer=$BGM
onready var musicscr=$window/TabContainer/Sound/MusicVol
onready var sfxscr=$window/TabContainer/Sound/SFXVol
onready var rev=$window/TabContainer/About/revision
onready var res=$window/TabContainer/Graphics/res
onready var ViewOptions=$window/TabContainer/Graphics/Label/ViewOptions
onready var TouchCtrl:CheckButton=$window/TabContainer/Control/TouchCtrl
#onready var ChildOptions=$window/TabContainer/Control/Label2/ChildOptions
onready var transit=$"/root/Transit"
var Size=Vector2()

func _ready():
#	scale=Vector2(1.5,1.5)
	Global.loadGameOptions()
	Global.loadGameState()
	res.text=str(OS.window_size)
	rev.text="rev:"+Global.revision
	SFX.volume_db=Global.SFXVol
	BGM.volume_db=Global.MusicVol
	TouchCtrl.set_pressed(Global.TouchCtrlEnabled)
	sfxscr.set_value(Global.SFXVol)
	musicscr.set_value(Global.MusicVol)
	ViewOptions.add_item("Window",0)
	ViewOptions.add_item("Screen",1)
	ViewOptions.select(OS.window_fullscreen)
	position=get_parent().get_viewport().size/2-$window.get_viewport().size*scale.x/2
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
	transit.change_scene("res://Menu/MainMenu.tscn")
	pass # Replace with function body.

func _on_ViewOptions_item_selected(index):
	if index==1:
		OS.window_fullscreen=true
	else:
		OS.window_fullscreen=false

func _on_TouchCtrl_toggled(button_pressed):
	Global.TouchCtrlEnabled=button_pressed
	pass # Replace with function body.
