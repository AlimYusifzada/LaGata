#global - autoload on startup
extends Node
#general constants
const revision="0.1.1"

const main_menu="res://MainMenu.tscn"

const file_GameState="user://gamestate"
const file_GameOptions="user://gameoptions"

#const MindTimerSet=.5
const GRAVITY = 1500
const TerminateVelocity=2000 #kill player
enum{PLAYER,GROUND,PLATFORM,LAVA,PRAY,ENEMY} #collision layers
const UP=Vector2(0,-1)
enum{Ykey,Gkey,Bkey} #Yellow,Green,Black keys index
var KeysRing=[0,0,0] #Yellow,Green,Black keys array
var Level:int=1 #current level
var LifesLeft:int
var PlayerAlive:bool=true #player life status - default true
var isChild:bool=true #player status (child/adult)
var Stamina=20 setget setStamina, getStamina
var MiceCatches:int #remove
var Points:int
var RecordPoints:int
var Ammo:int
const EnemyKillPrize=10
const EnemyJumpOff=1
#var PlayerPosition=Vector2()

var MusicVol=0
var SFXVol=0
var MasterVol=0
var TouchCtrlEnabled=true
#var JoystickMove=Vector2()
#var JoystickJump=false
var DblJumps:int
var MaxDblJumps:int
var MaxLifes:int=7
var PlayerPath:NodePath
var TDelta:float=0.0

var TJump=false
var TLeft=false
var TRight=false
var TSlip=false
var TRoll=false
var TShoot=false

func getPlayer()->Node:
	return get_tree().get_nodes_in_group("Cats")[0]
	pass

func addStamina(stam=0):
	var fl=false
	if Stamina<100 and (Stamina+stam)>=100 and isChild:
		Stamina=20
		isChild=false
		fl=true
	elif (Stamina+stam)<=0:
		isChild=true
	if isChild:
		Stamina+=stam/2
	else:
		Stamina+=stam/3
	pass
func setStamina(stam):
	Stamina=stam
	clamp(Stamina,0,100)
func getStamina()->int:
	return Stamina
	pass

func _ready():
	randomize()
#	saveGameOptions()
	loadGameOptions()

func PlayerReset(): # lost all progress
	KeysRing=[0,0,0] #Yellow,Green,Black keys array
	Level=1 
	LifesLeft=int(MaxLifes/2)
	PlayerAlive=true #player life status - default true
	isChild=true #player status (child/adult). what is a rule of change
	Stamina=20 #initial value
	MiceCatches=0
	Points=0
	Ammo=0
	MaxDblJumps=1
	DblJumps=MaxDblJumps
	saveGameState()
	pass

func getLockScene(level)->String:
	var pathS="res://Levels/"
	var pathM="lock"
	var pathE=".tscn"
	var levelpath=pathS+pathM+str(level)+pathE
	var levelfile=File.new()
	if levelfile.file_exists(levelpath):
		return levelpath
	else:
		return ''
	pass
	
func getLevelScene(level)->String:
	var pathS="res://Levels/"
	var pathM="level"
	var pathE=".tscn"
	var levelpath=pathS+pathM+str(level)+pathE
	var levelfile=File.new()
	if levelfile.file_exists(levelpath):
		return levelpath
	else:
		return ''
	pass

func checkChild():
	if Global.MiceCatches>100:
		Global.isChild=false
		Global.saveGameState()
	pass
	
func saveGameOptions():
	var GameOptions={
		"MasterVol":MasterVol,
		"SFXVol":SFXVol,
		"MusicVol":MusicVol,
		"TouchCtrlEnabled":TouchCtrlEnabled
		}
	var f=File.new()
	f.open(file_GameOptions,File.WRITE)
	f.store_line(to_json(GameOptions))
	f.close()
	pass

func saveGameState():
	if RecordPoints<Points:
		RecordPoints=Points
	var GameState={
		"Level":Level,
		"LifesLeft":LifesLeft,
		"MaxLifes":MaxLifes,
		"PlayerAlive":PlayerAlive,
		"isChild":isChild,
		"MiceCatches":MiceCatches,
		"Points":Points,
		"RecordPoints":RecordPoints,
		"Ammo":Ammo,
		"DblJumps":DblJumps,
		"MaxDblJumps":MaxDblJumps,
		"Stamina":Stamina,
		"YellowKeys":KeysRing[0],
		"GreenKeys":KeysRing[1],
		"BlackKeys":KeysRing[2]
		}
	var f=File.new()
	f.open(file_GameState,File.WRITE)
	f.store_line(to_json(GameState))
	f.close()
	pass

func loadGameOptions():
	var GameOptions={}
	var f=File.new()
	if f.file_exists(file_GameOptions):
		f.open(file_GameOptions,File.READ)
		GameOptions=parse_json(f.get_line())
		f.close()
		MusicVol=GameOptions["MusicVol"]
		SFXVol=GameOptions["SFXVol"]
		MasterVol=GameOptions["MasterVol"]
		TouchCtrlEnabled=GameOptions["TouchCtrlEnabled"]
		return
	else:
		saveGameOptions()
	pass

func loadGameState():
	var GameState={}
	var f=File.new()
	if f.file_exists(file_GameState):
		f.open(file_GameState,File.READ)
		GameState=parse_json(f.get_line())
		f.close()
		Level=GameState["Level"]
		LifesLeft=GameState["LifesLeft"]
		MaxLifes=GameState["MaxLifes"]
		PlayerAlive=GameState["PlayerAlive"]
		isChild=GameState["isChild"]
		MiceCatches=GameState["MiceCatches"]
		Points=GameState["Points"]
		Ammo=GameState["Ammo"]
		DblJumps=GameState["DblJumps"]
		MaxDblJumps=GameState["MaxDblJumps"]
		Stamina=GameState["Stamina"]
		RecordPoints=GameState["RecordPoints"]
		if Stamina<=0: Stamina=10
		KeysRing[0]=GameState["YellowKeys"]
		KeysRing[1]=GameState["GreenKeys"]
		KeysRing[2]=GameState["BlackKeys"]
		return
	else:
		saveGameState()
	pass
