extends StaticBody2D

export var SkullNumber=0
# Called when the node enters the scene tree for the first time.
func _ready():
	if SkullNumber>=0 && SkullNumber<3:
		$AnimatedSprite.set_frame(SkullNumber)
	pass # Replace with function body.

