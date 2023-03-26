extends Area2D

onready var flag=false

func _ready():
	scale=Vector2(0.7,0.7)
	$AnimatedSprite.frame=int(rand_range(0,7))
	$AnimatedSprite.play("default")
	$Tween.interpolate_property($".",
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),1,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($".",
	"scale",
	$".".scale,
	$".".scale+Vector2(0.3,0.3),1,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass

func _on_Coin_body_entered(body):
	if body.is_in_group("Cats") && !flag:
		set_collision_layer_bit(Global.PRAY,false)
		flag=true
		$Tween.start()
		body.emit_signal("Food")
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.
