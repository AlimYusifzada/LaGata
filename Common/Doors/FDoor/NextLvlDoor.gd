extends Area2D
onready var transit=$"/root/Transit"
export var LevelNumber=0

func _ready():
	if !Global.getLevelScene(LevelNumber):
		print("level not exist")
		queue_free()
	pass

func _on_NextLvlDoor_body_entered(body):
	if body.is_in_group("Cats"):
		body.set_physics_process(false)
		$AnimatedSprite.play()
		pass
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	Global.Level=LevelNumber
	Global.saveGameState()
	transit.change_scene(Global.getLevelScene(LevelNumber))
	pass # Replace with function body.
