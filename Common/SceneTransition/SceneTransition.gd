extends ColorRect

export var FadeIn=true
export var TransTime=3.0
signal Start
signal finished

func _ready():
	CheckFade()

func CheckFade():
	rect_size=OS.get_real_window_size()
	if FadeIn:
		$Fade.interpolate_property($".","color:a",
			1.0,0.0,TransTime,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	else:
		$Fade.interpolate_property($".","color:a",
			0.0,1.0,TransTime,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)	

func _on_Fade_tween_all_completed():
	visible=false
	$Fade.stop_all()
	emit_signal("finished")
	pass # Replace with function body.

func _on_SceneTransition_Start():
	CheckFade()
	visible=true
	$Fade.start()
	pass # Replace with function body.
