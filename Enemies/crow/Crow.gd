extends Node2D

var SHIT=preload("res://Enemies/crow/shit.tscn")
var pooping=false
var poopspawn=Vector2()

func _ready():
	Global.Crow=self
	poopspawn.y=position.y
	scale=Vector2(0.5,0.5)
	$AnimationPlayer.set_speed_scale(rand_range(0.7,1.0))
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Jump")
	pass # Replace with function body.

func _on_shitzone_body_entered(body):
	if body.is_in_group("Cats") && !pooping:
		pooping=true
		poopspawn.x=body.position.x
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	if pooping:
		pooping=false
		var poop=SHIT.instance()
		poop.position=poopspawn
		get_parent().add_child(poop)
	pass # Replace with function body.
