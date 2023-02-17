extends AnimatedSprite

var cloud="default"

func _ready():
	play(cloud)
	pass

func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass # Replace with function body.
