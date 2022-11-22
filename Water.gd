extends Area2D


func _ready():
	pass

func _on_Lava_body_entered(body):
	body.Life=false
	pass # Replace with function body.

