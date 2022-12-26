extends Sprite

var Spider=preload("res://Enemies/spider/spider.tscn")
var trigger=true
func _ready():
	pass

func _on_ambusher_body_entered(body):
	if body.is_in_group("Cats")&&trigger:
		trigger=false
		var sp=Spider.instance()
		sp.position=position
		get_parent().add_child(sp)
	pass # Replace with function body.
