#arrow

extends KinematicBody2D

const SCALE=Vector2(2,2)
var velocity=Vector2(0,0) # only x wiil change
onready var woosh=$woosh
onready var RemoveTimer=$RemoveTimer
onready var sprite=$arrow/Sprite

func _ready():
	set_scale(SCALE)
	woosh.volume_db=Global.SFXVol
	visible=true
	woosh.play()
	RemoveTimer.start(1)
	pass

func _process(delta):
	if velocity.x>0:
		sprite.flip_h=true
	else:
		sprite.flip_h=false
		
func _physics_process(delta):
	move_and_slide(velocity)
	pass

func _on_arrow_body_entered(body):
	if body.is_in_group("Cats"):
		body.emit_signal("Enemy")
		pass
		
func _on_RemoveTimer_timeout():
	queue_free()
	pass # Replace with function body.
