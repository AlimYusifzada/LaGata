extends RigidBody2D

export var Explosive=false
var Broken=false
const explosion=preload("res://Common/MovableObjects/Explosion.tscn")
onready var ASprite=$ASprite
signal Die

func _ready():
	if Explosive:
		ASprite.frame=1
	else:
		ASprite.frame=randi()%6+2
	pass

func _process(delta):
	if linear_velocity.y>300 && !Broken:
		Broken=true
	if Broken && is_equal_approx(linear_velocity.y,0.0):
		if Explosive:
			var boom=explosion.instance()
			boom.position=position
			get_parent().add_child(boom)
			queue_free()
		else: #change sprite
			set_mode(MODE_STATIC)
			ASprite.frame=0
			set_collision_layer_bit(Global.GROUND,true)
			set_collision_mask_bit(Global.ENEMY,true)
			set_collision_mask_bit(Global.PRAY,true)


func _on_MovableObject_Die():
	Broken=true
	pass # Replace with function body.
