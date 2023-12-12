extends Area2D

func _ready():
	$Lava.frame=randi()%3
	$Lava.play("default")
	pass

func _on_Lava_body_entered(body):
	body.Life=false
	pass # Replace with function body.

