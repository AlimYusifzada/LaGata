extends StaticBody2D

export var SnakeNumber=0
# Called when the node enters the scene tree for the first time.
func _ready():
	if SnakeNumber>=0 && SnakeNumber<2:
		$AnimatedSprite.set_frame(SnakeNumber)
	pass # Replace with function body.
