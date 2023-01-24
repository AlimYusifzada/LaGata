extends ColorRect

func _ready():
	rect_size=OS.get_real_window_size()
	$Fade.play("FadeOut")
	pass

func _on_Fade_animation_finished(anim_name):
	visible=false
	pass # Replace with function body.
