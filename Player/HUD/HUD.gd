#HUD

extends CanvasLayer

const LSCALE=Vector2(0.0,0.0)
const NSCALE=Vector2(.65,.65)
const BSCALE=Vector2(1.0,1.0)

onready var CatStat=$HUDPanel/CatStat
onready var Keys=$HUDPanel/Keys
onready var LvlCounter=$HUDPanel/LvlCounter
onready var BackgroundMusic=$BGM
onready var StaminaBar=$HUDPanel/CatStat/CatStamBar
onready var LifeBar=$HUDPanel/CatStat/CatLifeBar
onready var KeysCounter=$HUDPanel/Keys/KeysCounter
onready var PointsCounter=$HUDPanel/PointsCounter
onready var Ammo=$HUDPanel/Ammo
onready var AmmoCounter=$HUDPanel/Ammo/AmmoCounter

onready var Options=preload("res://Menu/Options.tscn")

signal OptionsChanged
signal UpdateHUD

var Praystot=0

func _ready():
	Global.loadGameOptions()
	BackgroundMusic.volume_db=Global.MusicVol
	BackgroundMusic.play()
	LvlCounter.text="Lvl="+str(Global.Level)
	pass
	
func _process(delta):
	CheckESC()

func CheckESC():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused=true
		Global.saveGameOptions()
		Global.saveGameState()
		var op=Options.instance()
		self.add_child(op)
		pass

func _on_HUD_OptionsChanged():
	Global.loadGameOptions()
	BackgroundMusic.volume_db=Global.MusicVol
	pass # Replace with function body.

func _on_CanvasLayer_UpdateHUD():
	
	if Global.DblJumps>1:
		$HUDPanel/DblJumpTimerInd.visible=true
	else:
		$HUDPanel/DblJumpTimerInd.visible=false
		
	LifeBar.bar_color=Color(range_lerp(Global.LifesLeft,1,7,1,0),
						  range_lerp(Global.LifesLeft,1,7,0,1),0)
	LifeBar.set_progress(Global.LifesLeft)
	
	StaminaBar.bar_color=Color(0,range_lerp(Global.Stamina,0,100,1,0),1)
	StaminaBar.set_progress(Global.Stamina)

	PointsCounter.text=str(Global.Points)
	KeysCounter.text=str(Global.KeysRing[0])
	AmmoCounter.text=str(Global.Ammo)
	
	if Global.KeysRing[0]==0:
		Keys.visible=false
	else:
		Keys.visible=true
	if Global.Ammo==0:
		Ammo.visible=false
	else:
		Ammo.visible=true

func _on_TouchESC_pressed():
	get_tree().paused=true
	Global.saveGameOptions()
	Global.saveGameState()
	var op=Options.instance()
	self.add_child(op)

