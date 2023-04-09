extends Node

export var OpenMessage="open"
export var CloseMessage="closed"
#onready 
signal SetOpen
signal SetClose

func _ready():
	pass # Replace with function body.
	
func _on_Node_SetClose():
	var cat=get_tree().get_nodes_in_group("Cats")[0]
	print(cat)
	if cat!=null:
		cat.emit_signal("Message",CloseMessage)
	else:
		print("player not found")
	pass # Replace with function body.

func _on_Node_SetOpen():
	var cat=get_tree().get_nodes_in_group("Cats")[0]
	print(cat)
	if cat!=null:
		cat.emit_signal("Message",OpenMessage)
	else:
		print("player not found")
	pass # Replace with function body.
