extends RigidBody2D

export var Explosive=false
var Broken=false
onready var explosion=preload("res://Common/MovableObjects/Explosion.tscn")

func _ready():
	pass

func _process(delta):
	if linear_velocity.y>500 && !Broken:
		Broken=true
	if Broken && is_equal_approx(linear_velocity.y,0.0):
		if Explosive:
			var boom=explosion.instance()
			boom.position=position
			get_parent().add_child(boom)
			queue_free()
		else:
			set_mode(MODE_STATIC)
			set_collision_layer_bit(Global.GROUND,true)
			set_collision_mask_bit(Global.ENEMY,true)
			set_collision_mask_bit(Global.PRAY,true)
