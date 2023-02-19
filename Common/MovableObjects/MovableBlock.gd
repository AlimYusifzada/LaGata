extends RigidBody2D

var Broken=false

func _ready():
	pass

func _process(delta):
	if linear_velocity.y>500 && !Broken:
		Broken=true
	if Broken && is_equal_approx(linear_velocity.y,0.0):
		$Label.text="broken" # remove label replace with animated sprite
		set_mode(MODE_STATIC)
		set_collision_layer_bit(Global.GROUND,true)
		set_collision_mask_bit(Global.ENEMY,true)
		set_collision_mask_bit(Global.PRAY,true)
