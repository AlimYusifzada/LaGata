#HUD

extends CanvasLayer

onready var CatStat=$HUDPanel/CatStat
onready var Keys=$HUDPanel/Keys
onready var LvlCounter=$HUDPanel/LvlCounter
onready var StaminaBar=$HUDPanel/CatStat/CatStamBar
onready var LifeBar=$HUDPanel/CatStat/CatLifeBar
onready var KeysCounter=$HUDPanel/Keys/KeysCounter
onready var PointsCounter=$HUDPanel/PointsCounter
onready var Ammo=$HUDPanel/Ammo
onready var AmmoCounter=$HUDPanel/Ammo/AmmoCounter

signal OptionsChanged
signal UpdateHUD

onready var Options=preload("res://Menu/Options.tscn")
onready var root=get_tree().get_root()

var Praystot=0

var LevelName=[
	'Purr-fect Playground',
	'Land of Whiskers I',
	'Land of Whiskers II',
	'Land of Whiskers III'
]

func _ready():
	set_visible(true)
	Global.loadGameOptions()
	LvlCounter.text=str(LevelName[Global.Level-1]) #replace number with name
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused=true
		Global.saveGameOptions()
		Global.saveGameState()
		var op=Options.instance()
		self.add_child(op)

func _on_HUD_OptionsChanged():
	Global.loadGameOptions()
	if Global.TouchCtrlEnabled:
		ShowCTouch()
	else:
		HideCTouch()
	pass # Replace with function body.

func _on_CanvasLayer_UpdateHUD():
	if Global.TouchCtrlEnabled:
		ShowHUD()
	else:
		HideCTouch()
	if Global.DblJumps>1:
		$HUDPanel/DblJumpTimerInd.visible=true
	else:
		$HUDPanel/DblJumpTimerInd.visible=false

	LifeBar.bar_color=Color(range_lerp(Global.LifesLeft,1,7,1,0),
						  range_lerp(Global.LifesLeft,1,7,0,1),0)
	LifeBar.set_progress(clamp(Global.LifesLeft,0,7))
	
	StaminaBar.bar_color=Color(0,range_lerp(Global.Stamina,0,100,1,0),1)
	StaminaBar.set_progress(clamp(Global.Stamina,0,100))

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

func _on_JumpBtn_pressed():
	Global.TJump=true
	pass # Replace with function body.

func _on_ShootBtn_pressed():
	Global.TShoot=true
	pass # Replace with function body.

func _on_SlideBtn_pressed():
	Global.TSlip=true
	pass # Replace with function body.

func _on_RollBtn_pressed():
	Global.TRoll=true
	pass # Replace with function body.

func _on_RightBtn_pressed():
	Global.TRight=true
	pass # Replace with function body.

func _on_LeftBtn_pressed():
	Global.TLeft=true
	pass # Replace with function body.

func _on_RollBtn_released():
	Global.TRoll=false
	pass # Replace with function body.

func _on_RightBtn_released():
	Global.TRight=false
	pass # Replace with function body.

func _on_LeftBtn_released():
	Global.TLeft=false
	pass # Replace with function body.

func HideHUD():
	$HUDPanel/Keys.visible=false
	$HUDPanel/CatStat.visible=false
	$HUDPanel/Ammo.visible=false
	$HUDPanel/DblJumpTimerInd.visible=false
	$CtrlPanel/LeftCtrl.visible=false
	$CtrlPanel/RightCtrl.visible=false
	pass
func ShowHUD():
	Global.TouchCtrlEnabled=true
	$HUDPanel/Keys.visible=true
	$HUDPanel/CatStat.visible=true
	$HUDPanel/Ammo.visible=true
	$CtrlPanel/LeftCtrl.visible=true
	$CtrlPanel/RightCtrl.visible=true
	pass
func HideCTouch():
	Global.TouchCtrlEnabled=false
	$CtrlPanel/LeftCtrl.visible=false
	$CtrlPanel/RightCtrl.visible=false
	pass
func ShowCTouch():
	Global.TouchCtrlEnabled=true
	$CtrlPanel/LeftCtrl.visible=true
	$CtrlPanel/RightCtrl.visible=true
