extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Ok_pressed():
	var root=get_tree().get_root()
	var main=root.get_node("Main")
	if main!=null:
		main.RemovePerson($Panel/Name.text.to_upper())
	queue_free()
	pass # Replace with function body.


func _on_Cancel_pressed():
	queue_free()
	pass # Replace with function body.


func _on_Ok2_pressed():# remove all
	var root=get_tree().get_root()
	var main=root.get_node("Main")
	if main!=null:
		main.delete_all()
	queue_free()
	pass # Replace with function body.
