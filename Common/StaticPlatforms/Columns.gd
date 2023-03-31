extends StaticBody2D


export var ColumnNumber=0
# Called when the node enters the scene tree for the first time.
func _ready():
	if ColumnNumber>=0 && ColumnNumber<3:
		$AnimatedSprite.set_frame(ColumnNumber)
	pass # Replace with function body.
