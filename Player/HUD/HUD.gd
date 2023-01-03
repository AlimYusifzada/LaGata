#HUD

extends CanvasLayer

const LSCALE=Vector2(0.0,0.0)
const NSCALE=Vector2(1.0,1.0)
const BSCALE=Vector2(2.5,2.5)
onready var CatStat=$HUDPanel/CatStat
onready var MiceStat=$HUDPanel/MiceStat
onready var Keys=$HUDPanel/Keys
onready var LvlCounter=$HUDPanel/LvlCounter
onready var LifeCounter=$HUDPanel/CatStat/LifeCounter
onready var StamCounter=$HUDPanel/CatStat/StamCounter
onready var MiceCounter=$HUDPanel/MiceStat/MiceCounter
onready var MiceLeft=$HUDPanel/MiceStat/MiceLeft
onready var KeysCounter=$HUDPanel/Keys/KeysCounter
onready var ScaleTimer=$ScaleTimer
onready var BackgroundMusic=$BGM
onready var Options=preload("res://Options.tscn")

signal OptionsChanged

func _ready():
	Global.loadGameOptions()
	BackgroundMusic.volume_db=Global.MusicVol
	BackgroundMusic.play()
	
	CatStat.scale=NSCALE
	MiceStat.scale=NSCALE
	Keys.scale=NSCALE
	LvlCounter.text="Lvl="+str(Global.Level)
	pass
	
func _process(delta):
	getsetVal()

func getsetVal():
	var l=int(LifeCounter.text)
	var s=int(StamCounter.text)
	var m=int(MiceCounter.text)
	var k=int(KeysCounter.text)
	if l!=Global.LifesLeft:
		LifeCounter.text=str(Global.LifesLeft)
	if s!=Global.Stamina*10:
		StamCounter.text=str(Global.Stamina)
	if m!=Global.MiceCatches:
		var prays=get_tree().get_nodes_in_group("Pray")
		MiceCounter.text=str(Global.MiceCatches)
		MiceLeft.text=str(len(prays))
		boom(MiceStat)
	elif m==0:
		MiceStat.scale=LSCALE #item dissappear
	if k!=Global.KeysRing[0]:
		KeysCounter.text=str(Global.KeysRing[0])
		boom(Keys)
	elif k==0:
		Keys.scale=LSCALE #item dissappear
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused=true
		var op=Options.instance()
		self.add_child(op)
		pass

func boom(obj):
	obj.scale=BSCALE
	if ScaleTimer.is_stopped():
		ScaleTimer.start(0.2)

func _on_ScaleTimer_timeout():
	CatStat.scale=NSCALE
	MiceStat.scale=NSCALE
	Keys.scale=NSCALE
	pass # Replace with function body.

func _on_HUD_OptionsChanged():
	Global.loadGameOptions()
	BackgroundMusic.volume_db=Global.MusicVol
	pass # Replace with function body.
