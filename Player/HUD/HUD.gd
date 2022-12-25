extends CanvasLayer

const LSCALE=Vector2(0.0,0.0)
const NSCALE=Vector2(1.0,1.0)
const BSCALE=Vector2(2.5,2.5)

func _ready():
	Global.HUD=self
	$HUDPanel/CatStat.scale=NSCALE
	$HUDPanel/MiceStat.scale=NSCALE
	$HUDPanel/Keys.scale=NSCALE
	$HUDPanel/LvlCounter.text="Lvl="+str(Global.Level)
	pass
	
func _process(delta):
	getsetVal()

func getsetVal():
	var l=int($HUDPanel/CatStat/LifeCounter.text)
	var s=int($HUDPanel/CatStat/StamCounter.text)
	var m=int($HUDPanel/MiceStat/MiceCounter.text)
	var k=int($HUDPanel/Keys/KeysCounter.text)
	if l!=Global.LifesLeft:
		$HUDPanel/CatStat/LifeCounter.text=str(Global.LifesLeft)
#	elif l==0:
#		$HUDPanel/CatStat.scale=LSCALE
	if s!=Global.Stamina*10:
		$HUDPanel/CatStat/StamCounter.text=str(Global.Stamina)
#	elif s==0:
#		$HUDPanel/CatStat.scale=LSCALE
	if m!=Global.MiceCatches:
		var prays=get_tree().get_nodes_in_group("Pray")
		$HUDPanel/MiceStat/MiceCounter.text=str(Global.MiceCatches)
		$HUDPanel/MiceStat/MiceLeft.text=str(len(prays))
		boom($HUDPanel/MiceStat)
	elif m==0:
		$HUDPanel/MiceStat.scale=LSCALE #item dissappear
	if k!=Global.KeysRing[0]:
		$HUDPanel/Keys/KeysCounter.text=str(Global.KeysRing[0])
		boom($HUDPanel/Keys)
	elif k==0:
		$HUDPanel/Keys.scale=LSCALE #item dissappear

func boom(obj):
	obj.scale=BSCALE
	if $ScaleTimer.is_stopped():
		$ScaleTimer.start(0.2)

func _on_ScaleTimer_timeout():
	$HUDPanel/CatStat.scale=NSCALE
	$HUDPanel/MiceStat.scale=NSCALE
	$HUDPanel/Keys.scale=NSCALE
	pass # Replace with function body.
