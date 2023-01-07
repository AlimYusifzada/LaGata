extends Node2D
onready var AnSprite:AnimatedSprite=$AnSprite
onready var APlayer:AnimationPlayer=$APlayer
var jump:bool=false
var jumper:Node=null
export var JumPower=30
func _ready():
	pass # Replace with function body.
func _on_Area2D_body_entered(body):
	APlayer.play("bounce")
	if body.is_in_group("Cats"):
		if body.velocity.y>0:
			body.emit_signal("Jump",body.velocity.y/10+JumPower)
		else:
			body.emit_signal("Jump",JumPower)
	pass # Replace with function body.
