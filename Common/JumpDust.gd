extends CPUParticles2D


func _ready():
	$EndTimer.start(2)
	pass


func _on_EndTimer_timeout():
	queue_free()
	pass # Replace with function body.
