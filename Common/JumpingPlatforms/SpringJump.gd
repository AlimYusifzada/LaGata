extends Node2D
onready var AnSprite:AnimatedSprite=$AnSprite
onready var APlayer:AnimationPlayer=$APlayer
var jump:bool=false
var jumper:Node=null
export var JumPower=50 # value 50 will let jump up to 5 tiles
# 
func _ready():
	pass # Replace with function body.
func _on_Area2D_body_entered(body):
	APlayer.play("bounce")
	if body.is_in_group("Cats"):
		var stJump=body.velocity.y/Global.GRAVITY
		if body.velocity.y>0:
			body.emit_signal("Jump",stJump+JumPower)
		else:
			body.emit_signal("Jump",stJump)
	pass # Replace with function body.
