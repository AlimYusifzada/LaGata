#crow

extends Node2D

onready var SHIT=preload("res://Enemies/crow/shit.tscn")
var pooping=false
var poopspawn=Vector2()
onready var CrowAnimation=$AnimationPlayer
onready var Feathers=$feathers
onready var Scream=$Crow/scream

func _ready():
	poopspawn.y=position.y
	scale=Vector2(0.6,0.6)
	CrowAnimation.set_speed_scale(rand_range(0.7,1.0))
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Jump",10)
		body.emit_signal("Message","crow jump!")
		Feathers.position=$Crow.position
		Feathers.set_emitting(true)
		Scream.play()
		Global.Points+=50
	pass # Replace with function body.

func _on_shitzone_body_entered(body):
	if body.is_in_group("Cats") && !pooping:
		pooping=true
		poopspawn.x=body.position.x
		body.emit_signal("Message","crow above!")
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	Scream.volume_db=Global.SFXVol
	if pooping:
		pooping=false
		var poop=SHIT.instance()
		poop.position=poopspawn
		get_parent().add_child(poop)
#	Scream.stop()
	pass # Replace with function body.
