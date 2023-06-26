extends Node2D
export var SpawnDelay=10 #sec
export var Link2Object="" #

var SpawnObject
func _ready():
	SpawnObject=load(Link2Object)
	if SpawnObject:
#		print(SpawnObject.get_instance_id())
		$DelayTime.start(SpawnDelay)
	pass # Replace with function body.

func _on_DelayTime_timeout():
	var obj=SpawnObject.instance()
	obj.position=position
	get_parent().add_child(obj)
	pass # Replace with function body.
