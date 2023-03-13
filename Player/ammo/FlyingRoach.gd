extends KinematicBody2D

var RoachSpeed=0.0
var velocity=Vector2(0,0)
var SCALE=Vector2(.5,.5)
const Cloud=preload("res://Common/64xt/BloodExplosion/BloodExplosion.tscn")
onready var roachSprite=$AnimatedSprite
onready var removeTimer=$Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	scale=SCALE
	removeTimer.start(1)
	velocity.x=RoachSpeed
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x=RoachSpeed*delta
	if velocity.x>0:
		roachSprite.flip_h=false
	else:
		roachSprite.flip_h=true
	pass
	move_and_collide(velocity)
	
func _on_Timer_timeout():
	puff()
	queue_free()
	pass # Replace with function body.

func _on_DamageZone_body_entered(body):
	RoachSpeed=RoachSpeed/100
	body.emit_signal("Die")
	Global.Points+=100
	puff()
	pass # Replace with function body.

func puff():
	var cl=Cloud.instance()
	cl.cloud="brown"
	cl.position=position
	get_parent().add_child(cl)
