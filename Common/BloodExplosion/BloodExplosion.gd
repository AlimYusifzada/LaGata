extends AnimatedSprite

var cloud="default"

func _ready():
	$APLayer.volume_db=Global.SFXVol
	$APLayer.play()
	play(cloud)
	pass

func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass # Replace with function body.
