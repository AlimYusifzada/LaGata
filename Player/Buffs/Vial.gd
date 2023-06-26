extends Area2D

export var VialType=0 #0- stamina 1- life

func _ready():
	$AnimatedSprite.set_frame(VialType)
	$Tween.interpolate_property($".",
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),0.3,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($".",
		"scale",
		$".".scale,
		$".".scale+Vector2(0.3,0.3),1,
		Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass

func _on_Vial_body_entered(body):
	if body.is_in_group("Cats"):
		set_collision_mask_bit(Global.PLAYER,false)
		if VialType==0:
			body.emit_signal("Food",50)
		elif VialType==1:
			body.emit_signal("Food",10)
			if Global.LifesLeft<Global.MaxLifes:
				Global.LifesLeft+=1
		$Tween.start()
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.
