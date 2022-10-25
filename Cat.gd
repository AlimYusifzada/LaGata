extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED=150
var standup=false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("sit")
	$AnimatedSprite.playing=false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity=Vector2()
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		velocity.x=SPEED
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		velocity.x=-SPEED
		$AnimatedSprite.flip_h=false
		$AnimatedSprite.play("walk")
	elif Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		velocity.x=0
		$AnimatedSprite.play("tosit")
	else:
		velocity.x=0
	move_and_slide(velocity)
	pass


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.animation="sit"
	$AnimatedSprite.playing=false
	pass # Replace with function body.
