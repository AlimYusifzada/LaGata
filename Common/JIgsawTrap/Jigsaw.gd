extends AnimatedSprite

export var JigsawNumber=0
export var rad=5
# Called when the node enters the scene tree for the first time.
func _ready():
	set_frame(JigsawNumber)
	pass # Replace with function body.

func _process(delta):
	rotate(rad*delta)

func _on_Area2D_body_entered(body):
	body.emit_signal("Die")
	pass # Replace with function body.
