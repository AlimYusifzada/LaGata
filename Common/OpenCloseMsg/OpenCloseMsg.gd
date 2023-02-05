extends Node

export var OpenMessage="traps deactivated!"
export var CloseMessage="traps active!"
onready var cat=get_tree().get_nodes_in_group("Cats")[0]
signal SetOpen
signal SetClose

func _ready():
	pass # Replace with function body.
	
func _on_Node_SetClose():
	if cat!=null:
		cat.emit_signal("Message",CloseMessage)
	pass # Replace with function body.

func _on_Node_SetOpen():
	if cat!=null:
		cat.emit_signal("Message",OpenMessage)
	pass # Replace with function body.
