extends AnimatedSprite


export var TimerSet=10 #sec
const  Enemy=preload("res://Enemies/pray/Roach.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start(TimerSet)
	pass # Replace with function body.

func _on_SpawnTimer_timeout():
	var obj=Enemy.instance()
	obj.position=position
	get_parent().add_child(obj)
	pass # Replace with function body.
