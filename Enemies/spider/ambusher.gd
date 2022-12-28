#ambusher (animation?) spider waiting for the pray
extends Sprite

onready var Spider=preload("res://Enemies/spider/spider.tscn")
onready var trigger=false

func _ready():
	pass

func _process(delta):
	if trigger:
		var sp=Spider.instance()
		sp.position=position
		get_parent().add_child(sp)
		queue_free()

func _on_ambusher_body_entered(body):
	if body.is_in_group("Cats"):
		trigger=true
