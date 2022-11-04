extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Ok_pressed():
	var root=get_tree().get_root()
	var main=root.get_node("Main")
	if main!=null:
		main.AddNewPerson($Panel/Name.text.to_upper(),$Panel/VisitorBox.pressed)
	queue_free()
	pass # Replace with function body.

func _on_Cancel_pressed():
	queue_free()
	pass # Replace with function body.
