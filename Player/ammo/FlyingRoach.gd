extends KinematicBody2D


var velocity=Vector2(0,0)
var SCALE=Vector2(.5,.5)
const Cloud=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")
onready var roachSprite=$AnimatedSprite
onready var removeTimer=$Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	scale=SCALE
	removeTimer.start(1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.x>0:
		roachSprite.flip_h=false
	else:
		roachSprite.flip_h=true
	pass
func _physics_process(delta):
	move_and_collide(velocity)
	
func _on_Timer_timeout():
	puff()
	queue_free()
	pass # Replace with function body.

func _on_DamageZone_body_entered(body):
	body.emit_signal("Die")
	velocity.x=0
	puff()
	pass # Replace with function body.

func puff():
	var cl=Cloud.instance()
	cl.cloud="brown"
	cl.position=position
	get_parent().add_child(cl)
