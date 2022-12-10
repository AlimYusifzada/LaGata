extends Sprite

func _ready():
	scale=Vector2(0.5,0.5)
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"):
		Global.KeysRing[Global.Ykey]+=1
		$Timer.start(0.1)
	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
