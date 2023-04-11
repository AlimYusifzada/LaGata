#key (gold)
extends Sprite

func _ready():
	scale=Vector2(0.5,0.5)
	$Tween.interpolate_property($".",
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),0.5,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($".",
	"scale",
	$".".scale,
	$".".scale+Vector2(0.3,0.3),0.5,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats"):
		$Area2D.set_collision_mask_bit(Global.PLAYER,false)
		body.emit_signal("Food",1)
		Global.KeysRing[Global.Ykey]+=1
		$Tween.start()
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.
