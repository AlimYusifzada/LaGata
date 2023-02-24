extends Node

export var OpenMessage="traps deactivated!"
export var CloseMessage="traps active!"
#onready 
signal SetOpen
signal SetClose

func _ready():
	pass # Replace with function body.
	
func _on_Node_SetClose():
	var cat=get_tree().get_nodes_in_group("Cats")[0]
	if cat!=null:
		cat.emit_signal("Message",CloseMessage)
	pass # Replace with function body.

func _on_Node_SetOpen():
	var cat=get_tree().get_nodes_in_group("Cats")[0]
	if cat!=null:
		cat.emit_signal("Message",OpenMessage)
	pass # Replace with function body.
