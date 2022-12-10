extends StaticBody2D

export var DoorColor=Global.Ykey

func _ready():
	scale=Vector2(1,1)
	$AnimatedSprite.play("open",true)
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cats") && Global.KeysRing[DoorColor]>0:
		$AnimatedSprite.play("open")
		set_collision_mask_bit(Global.PLAYER,false)
		Global.KeysRing[DoorColor]-=1
		body.emit_signal("Message","the door is open")
	elif body.is_in_group("Cats") && Global.KeysRing[DoorColor]<=0:
		Global.KeysRing[DoorColor]=0
#		set_collision_mask_bit(Global.M_PLAYER,true)
		#$AnimatedSprite.play("closed")
		body.emit_signal("Message","the door is closed,\nyou need a key!")
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("Cats") && $AnimatedSprite.get_animation()=="open":
		$AnimatedSprite.play("open",true)
		set_collision_mask_bit(Global.PLAYER,true)
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	pass # Replace with function body.
