extends Area2D

onready var Smoke=preload("res://Common/JumpDust.tscn")

func _ready():
	$Lava.play("default")
	pass

func _on_Lava_body_entered(body):
	body.Life=false
	var sm=Smoke.instance()
	sm.position=body.position
	sm.set_amount(10)
	get_parent().add_child(sm)
	pass # Replace with function body.

