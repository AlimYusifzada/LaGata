extends AnimatedSprite

export var plantnum=1

func _ready():
	play("Plant"+str(plantnum))
	pass
