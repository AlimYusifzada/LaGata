extends Area2D

export var DoubleJumps=1
var flag=false

func _ready():
	$AnimatedSprite/Label.text=str(DoubleJumps)
	$Tween.interpolate_property($".",
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),1,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	pass

func _on_DblJumpBonus_body_entered(body):
	if body.is_in_group("Cats") && !flag:
		Global.DblJumps+=DoubleJumps
		body.emit_signal("Message","Double Jump counter: %s"%(Global.DblJumps-1))
		set_collision_layer_bit(Global.PRAY,false)
		flag=true
		$Tween.start()
		pass
	pass # Replace with function body.

func _on_Tween_tween_all_completed():
	queue_free()
	pass # Replace with function body.