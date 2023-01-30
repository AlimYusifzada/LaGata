extends AnimatedSprite

var LowFlameDone=false
var HiFlameDone=false

signal SetOpen
signal SetClose
enum {IDLE,ACTIVE,SLEEP}
var state=IDLE
export var delay=3

func _ready():
	$Light.enabled=false
	pass

func _process(delta):
	match state:
		IDLE:
			play("dead")
		ACTIVE:
			$Timer.stop()
			play("default")
			check_body()
		_: play("dead")

func check_body():
	$CheckBody.force_raycast_update()
	var body=$CheckBody.get_collider()
	if body:
		body.emit_signal("Die")	
	$CheckBodyW.force_raycast_update()
	body=$CheckBodyW.get_collider()
	if body:
		body.emit_signal("Die")
	$CheckBodyE.force_raycast_update()
	body=$CheckBodyE.get_collider()
	if body:
		body.emit_signal("Die")


func set_mask(val):
	$CheckBody.set_collision_mask_bit(Global.PLAYER,val)
	$CheckBody.set_collision_mask_bit(Global.PRAY,val)
	$CheckBody.set_collision_mask_bit(Global.ENEMY,val)
	$CheckBodyE.set_collision_mask_bit(Global.PLAYER,val)
	$CheckBodyE.set_collision_mask_bit(Global.PRAY,val)
	$CheckBodyE.set_collision_mask_bit(Global.ENEMY,val)
	$CheckBodyW.set_collision_mask_bit(Global.PLAYER,val)
	$CheckBodyW.set_collision_mask_bit(Global.PRAY,val)
	$CheckBodyW.set_collision_mask_bit(Global.ENEMY,val)

func _on_FlameTrap_SetOpen():
	state=SLEEP
	pass # Replace with function body.

func _on_FlameTrap_SetClose():
	state=IDLE
	pass # Replace with function body.

func _on_Timer_timeout():
	if state!=SLEEP:
		state=ACTIVE
		$Light.enabled=true
		set_mask(true)
	pass # Replace with function body.

func _on_flame_animation_finished():
	set_mask(false)
	if $Timer.is_stopped():
		$Timer.start(delay)
	if state==ACTIVE:
		state=IDLE
		$Light.enabled=false
	pass # Replace with function body.

