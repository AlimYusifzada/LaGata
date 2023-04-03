extends AnimatedSprite

onready var ws=$WestShrap
onready var es=$EastShrap
onready var ns=$NorthShrap
onready var nw=$NWShrap
onready var ne=$NEShrap
onready var ss=$SouthShrap
onready var sw=$SWShrap
onready var se=$SEShrap

func _ready():
	$Boom.volume_db=Global.SFXVol
	$Boom.play()
	play("default")
	pass

func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass # Replace with function body.

func _process(delta):
	if get_frame()>1 && get_frame()<6:
		if ws.get_collider():
			ws.get_collider().emit_signal("Die")
		if es.get_collider():
			es.get_collider().emit_signal("Die")
		if ns.get_collider():
			ns.get_collider().emit_signal("Die")
		if nw.get_collider():
			nw.get_collider().emit_signal("Die")
		if ne.get_collider():
			ne.get_collider().emit_signal("Die")
		if sw.get_collider():
			sw.get_collider().emit_signal("Die")
		if se.get_collider():
			se.get_collider().emit_signal("Die")
		if ss.get_collider():
			ss.get_collider().emit_signal("Die")
	pass
