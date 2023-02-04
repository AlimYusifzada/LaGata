#crows poo

extends KinematicBody2D

const SCALE=Vector2(0.7,0.7)
var velocity=Vector2(0,0)
onready var RemoveTimer=$RemoveTimer

func _ready():
	velocity.y=700
	set_scale(SCALE)
	RemoveTimer.start(2)
	pass

func _physics_process(delta):
	move_and_slide(velocity,Global.UP)
	
func _on_RemoveTimer_timeout():
	queue_free()
	pass # Replace with function body.

func _on_DamageArea_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Food",-3)
		body.emit_signal("Message","stamina:"+str(Global.Stamina))
	pass # Replace with function body.
