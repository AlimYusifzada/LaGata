extends Area2D


func _ready():
	pass


func _on_NextLvlDoor_body_entered(body):
	if body.is_in_group("Cats"):
		$AnimatedSprite.play()
		pass
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	pass # Replace with function body.
