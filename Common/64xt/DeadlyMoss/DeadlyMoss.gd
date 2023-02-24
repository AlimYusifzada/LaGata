extends Area2D

func _ready():
	pass

func _on_DeadlyMoss_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Die")
	pass # Replace with function body.
