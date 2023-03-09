#global - autoload on startup
extends Node
#general constants
const revision="0.1"

const main_menu="res://MainMenu.tscn"

const file_GameState="user://gamestate"
const file_GameOptions="user://gameoptions"

const MindTimerSet=.5
const GRAVITY = 1500
enum{PLAYER,GROUND,PLATFORM,LAVA,PRAY,ENEMY}
const UP=Vector2(0,-1)
enum{Ykey,Gkey,Bkey} #Yellow,Green,Black keys index
var KeysRing=[0,0,0] #Yellow,Green,Black keys array
var Level=0 #current level
var LifesLeft:int=7
var PlayerAlive:bool=true #player life status - default true
var isChild:bool=true #player status (child/adult)
var Stamina=10	#initial value
var MiceCatches=0
var Points=0
var Ammo=0
#var PlayerPosition=Vector2()

var MusicVol=0
var SFXVol=0
var MasterVol=0
#var JoystickMove=Vector2()
#var JoystickJump=false
var DblJumps:int
var MaxDblJumps:int=1
var MaxLifes:int=7

func _ready():
	loadGameOptions()
#	PlayerReset()
	randomize()

func PlayerReset():
	KeysRing=[0,0,0] #Yellow,Green,Black keys array
	Level=0 #current level
	LifesLeft=MaxLifes 
	PlayerAlive=true #player life status - default true
	isChild=true #player status (child/adult). what is a rule of change
	Stamina=10 #initial value
	MiceCatches=0
	Points=0
	Ammo=0
	DblJumps=MaxDblJumps
	saveGameState()
	pass

func getLevelScene(level):
	var pathS="res://Levels/"
	var pathM="level"
	var pathE=".tscn"
	var levelpath=pathS+pathM+str(level)+pathE
	var levelfile=File.new()
	if levelfile.file_exists(levelpath):
		return levelpath
	else:
		return null
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
		"MusicVol":MusicVol
		}
	var f=File.new()
	f.open(file_GameOptions,File.WRITE)
	f.store_line(to_json(GameOptions))
	f.close()
	pass
		
func saveGameState():
	var GameState={
		"Level":Level,
		"LifesLeft":LifesLeft,
		"MaxLifes":MaxLifes,
		"PlayerAlive":PlayerAlive,
		"isChild":isChild,
		"MiceCatches":MiceCatches,
		"Points":Points,
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
		KeysRing[0]=GameState["YellowKeys"]
		KeysRing[1]=GameState["GreenKeys"]
		KeysRing[2]=GameState["BlackKeys"]
		return
	else:
		saveGameState()
	pass
