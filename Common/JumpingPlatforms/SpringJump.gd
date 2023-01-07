extends Node2D
onready var AnSprite:AnimatedSprite=$AnSprite
onready var APlayer:AnimationPlayer=$APlayer
var jump:bool=false
var jumper:Node=null
func _ready():
	pass # Replace with function body.
func _on_Area2D_body_entered(body):
	APlayer.play("bounce")
	if body.is_in_group("Cats"):
		body.emit_signal("Jump",30)
	pass # Replace with function body.
