extends Node
#scenes

#general constants
const GRAVITY = 1500
enum{PLAYER,GROUND,PLATFORM,LAVA,PRAY,ENEMY}
const UP=Vector2(0,-1)
#Player(game) parameters
enum{Ykey,Gkey,Bkey} #Yellow,Green,Black keys index
var KeysRing=[0,0,0] #Yellow,Green,Black keys array
var Level=0 #current level
var LifesLeft=7
var PlayerAlive=true #player life status - default true
var isChild=false #player status (child/adult)
var Stamina=10	#initial value
var MiceCatches=0

#modules (objects)
var Cat

var Mouse
var Xen
var HUD
var Arrow
var Crow
var Shit

func getLevelScene(level):
	var pathS="res://Levels/"
	var pathM="level"
	var pathE=".tscn"
	pass
