extends Node

const GRAVITY = 1500
const GROUND=1 				# ground layer, user cant jump off the ground 
const PLATFORM=2            # platforms layer, user can jump on and off the platform
const UP=Vector2(0,-1)

var GameState
var Cat
var Mouse
var Xen
var HUD
var Arrow
