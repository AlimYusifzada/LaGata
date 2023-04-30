extends Area2D
onready var transit=$"/root/Transit"

func _ready():
	if !Global.getLockScene(Global.Level):
		push_error("there should be a file lock#.tscn")
		push_error("if you are at level1.tscn -> lock1.tscn")
		queue_free()
	pass

func _on_NextLvlDoor_body_entered(body):
	if body.is_in_group("Cats"):
		transit.change_scene(Global.getLockScene(Global.Level))
		pass
	pass # Replace with function body.
	
