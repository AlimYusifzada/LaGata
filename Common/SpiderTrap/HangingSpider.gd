extends Node2D

export var Depth="a1"
onready var Ambush=$Ambush
# Called when the node enters the scene tree for the first time.
func _ready():
#	Ambush.play("a128") test
	pass # Replace with function body.

func _on_Watch128_body_entered(body):
	Ambush.play("a128")
	pass # Replace with function body.


func _on_Ambush_animation_finished(anim_name):
	Ambush.stop()
	pass # Replace with function body.

func _on_damagezone_body_entered(body):
	body.emit_signal("Die")
	pass # Replace with function body.
