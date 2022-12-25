extends Node2D


func _ready():
	randomize()
	$CatYawDelay.start(rand_range(3.0,15.0))
	Global.loadGameState()
	$BGMusic.play()
	if Global.LifesLeft<=0:
		$Comtinue.disabled=true
	else:
		$Comtinue.disabled=false
	pass
	
func _process(delta):
	var eye_position=get_global_mouse_position()-$CatYaw.position
	if !$CatYaw.playing:
		if eye_position.x<-100:
			$CatYaw.play("lookright")
			pass
		elif eye_position.x>100:
			$CatYaw.play("lookleft")
			pass
		else:
			$CatYaw.play("default")
			pass
		$CatYaw.stop()
	pass
	
func _on_StartNewGame_pressed():
	Global.PlayerReset()
	get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.

func _on_Exit_pressed():
	Global.saveGameState()
	get_tree().quit(0)
	pass # Replace with function body.

func _on_Comtinue_pressed():
	if Global.LifesLeft>0:
		Global.PlayerAlive=true
		get_tree().change_scene("res://Main.tscn")
	pass # Replace with function body.

func _on_CatYawDelay_timeout():
	$CatYaw.play("yaw")
	pass # Replace with function body.

func _on_CatYaw_animation_finished():
	$CatYaw.stop()
	$CatYawDelay.start(rand_range(3.0,10.0))
	pass # Replace with function body.
