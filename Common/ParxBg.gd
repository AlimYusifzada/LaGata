extends ParallaxBackground

onready var Space=$sky
onready var Clouds=$clouds
onready var Far=$far
onready var Mid=$mid
onready var Close=$close
onready var Same=$same

const width=1980
const height=1080

export var enSky:bool
export var txSky:Texture
export var enClouds:bool
export var txClouds:Texture
export var enFar:bool
export var txFar:Texture
export var enMid:bool
export var txMid:Texture
export var txMidB:Texture
export var enClose:bool
export var txClose:Texture
export var txCloseB:Texture
export var enSame:bool
export var txSame:Texture
export var txSameB:Texture
# Called when the node enters the scene tree for the first time.
func _ready():
	$sky.visible=enSky
	$sky/Sprite.set_texture(txSky)
	
	$clouds.visible=enClouds
	$clouds/Sprite.set_texture(txClouds)
	
	$far.visible=enFar
	$far/Sprite.set_texture(txFar)
	
	$mid.visible=enMid
	$mid/Sprite.set_texture(txMid)
	$mid/SpriteB.set_texture(txMidB)
	$close.visible=enClose
	$close/Sprite.set_texture(txClose)
	$close/SpriteB.set_texture(txCloseB)
	$same.visible=enSame
	$same/Sprite.set_texture(txSame)
	$same/SpriteB.set_texture(txSameB)
	pass # Replace with function body.

