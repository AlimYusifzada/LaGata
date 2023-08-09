extends Area2D
onready var transit=$"/root/Transit"
export var NextLevel=0

func _ready():
	if NextLevel<0:
		if !Global.getLockScene(Global.Level):
			push_error("there should be a file lock#.tscn")
			push_error("like: for level1.tscn required lock1.tscn")
			queue_free()
	pass

func _on_NextLvlDoor_body_entered(body):
	if body.is_in_group("Cats"):
		if NextLevel<0:
			transit.change_scene(Global.getLockScene(Global.Level))
		elif NextLevel==0:
			transit.change_scene(Global.main_menu)
		else:
			Global.Level=NextLevel
			Global.saveGameState()
			transit.change_scene((Global.getLevelScene(NextLevel)))
		pass
	pass # Replace with function body.
	
