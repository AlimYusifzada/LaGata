extends Area2D


func _ready():
	
	pass

func _on_Lava_body_entered(body):
	body.Life=false
	$Smoke.visible=true
	$Smoke.play("default")
	pass # Replace with function body.

func _on_Smoke_animation_finished():
	$Smoke.visible=false
	pass # Replace with function body.
