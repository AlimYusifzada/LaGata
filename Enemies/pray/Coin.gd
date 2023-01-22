extends Area2D

onready var flag=false

func _ready():
	scale=Vector2(0.13,0.13)
	$AnimatedSprite.frame=int(rand_range(0,7))
	$AnimatedSprite.play("default")
	pass

func _on_Coin_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food")
		flag=true		
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if flag:
		queue_free()
	pass # Replace with function body.
