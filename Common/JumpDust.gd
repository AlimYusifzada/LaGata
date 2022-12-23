extends CPUParticles2D


func _ready():
	$EndTimer.start(1)
	pass


func _on_EndTimer_timeout():
	queue_free()
	pass # Replace with function body.
