extends Node

const GRAVITY = 1500
const GROUND=1 				# ground layer, user cant jump off the ground 
const PLATFORM=2            # platforms layer, user can jump on and off the platform
const UP=Vector2(0,-1)

enum Key{Yellow,Green,Black}
var KeysRing=[0,0,0] #Yellow,Green,Black
var Level=0 #current level
var LifesLeft=7
var Stamina=10	#initial value
var MiceCatches=0

#var GameState
var Cat
var Mouse
var Xen
var HUD
var Arrow
var Crow
var Shit
