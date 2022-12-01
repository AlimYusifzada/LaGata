extends Node

#general constants
const GRAVITY = 1500
#const GROUND=1# ground layer, user cant jump off the ground 
#const PLATFORM=2# platforms layer, user can jump on and off the platform
enum{PLAYER,GROUND,PLATFORM,LAVA,PRAY,ENEMY}
const UP=Vector2(0,-1)
#Player parameters
var KeysRing=[0,0,0] #Yellow(),Green,Black
var Level=0 #current level
var LifesLeft=7
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
