extends Node2D

onready var SFX:AudioStreamPlayer=$SFXTest
onready var BGM:AudioStreamPlayer=$BGM
onready var musicscr=$window/TabContainer/Sound/MusicVol
onready var sfxscr=$window/TabContainer/Sound/SFXVol
onready var rev=$window/TabContainer/About/revision
onready var ViewOptions=$window/TabContainer/Graphics/ViewOptions
onready var WinResOptions=$window/TabContainer/Graphics/WinResOptions
onready var TouchCtrl:CheckButton=$window/TabContainer/Control/TouchCtrl
#onready var ChildOptions=$window/TabContainer/Control/Label2/ChildOptions
onready var transit=$"/root/Transit"
var Size=Vector2()

func _ready():
#	scale=Vector2(1.5,1.5)
	Global.loadGameOptions()
	Global.loadGameState()
	rev.text="rev:"+Global.revision
	SFX.volume_db=Global.SFXVol
	BGM.volume_db=Global.MusicVol
	TouchCtrl.set_pressed(Global.TouchCtrlEnabled)
	sfxscr.set_value(Global.SFXVol)
	musicscr.set_value(Global.MusicVol)
	
	ViewOptions.add_item("Window",0)
	ViewOptions.add_item("Screen",1)
	ViewOptions.select(OS.window_fullscreen)
	
	WinResOptions.set_disabled(OS.window_fullscreen)
	WinResOptions.add_item("864 x 480",0)
	WinResOptions.add_item("1024 x 600",1)
	WinResOptions.add_item("1280 x 720",2)
	WinResOptions.add_item("1920 x 1080",3)
	match OS.get_window_size():
		Vector2(864,480): WinResOptions.select(0)
		Vector2(1024,600): WinResOptions.select(1)
		Vector2(1280,720): WinResOptions.select(2)
		Vector2(1920,1080): WinResOptions.select(3)
			
	set_position(get_parent().get_viewport().size/2-$window.get_viewport().size*scale.x/2)
	pass

func _on_CancelButton_pressed():
#	Global.loadGameOptions()
	get_tree().paused=false
#	get_parent().emit_signal("OptionsChanged")
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
	match index:
		-1: pass
		0:
			OS.set_window_fullscreen(false)
		1:
			OS.set_window_fullscreen(true)
	WinResOptions.set_disabled(OS.window_fullscreen)

func _on_TouchCtrl_toggled(button_pressed):
	Global.TouchCtrlEnabled=button_pressed
	pass # Replace with function body.


func _on_WinResOptions_item_selected(index):
	match index:
		0:
			OS.set_window_size(Vector2(864,480))
		1:
			OS.set_window_size(Vector2(1024,600))
		2:
			OS.set_window_size(Vector2(1280,720))
		3:
			OS.set_window_size(Vector2(1920,1080))
		-1: pass
	set_position(get_parent().get_viewport().size/2-$window.get_viewport().size*scale.x/2)
