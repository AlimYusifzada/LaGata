extends StaticBody2D

export var CylinderNumber=-1

func _ready():
	if CylinderNumber<0 || CylinderNumber>9:
		CylinderNumber=randi()%9
	$AnimatedSprite.set_frame(CylinderNumber)
	pass
