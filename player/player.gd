# Reference: https://www.youtube.com/watch?v=BeSJgUTLmk0
extends KinematicBody2D

const MAX_SPEED = 250
const ACCELERATION = 2000
var motion = Vector2.ZERO

func get_input_axis():
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# If vector isn't normalized, then diagonal directions would make player move faster.
	return Vector2(horizontal, vertical).normalized()

func apply_friction(amount):
	# If our motion vector is larger than our friction value, apply friction to our vector.
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	# Otherwise, our motion is not enough to overcome friction, so ZERO out the vector.
	else:
		motion = Vector2.ZERO

# Apply our acceleration vector to our motion vector.
# Limit the motion vector to the MAX_SPEED constant.
func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

# https://godotengine.org/qa/38365/what-the-difference-between-_physicsprocess-and-_process
func _physics_process(delta):
	var axis = get_input_axis()
	# Vector2.ZERO means if there is no input?
	# If so then apply any sort of friction calculation.
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	# move_and_slide is built into godot (kinematic body)
	# It returns "leftover" motion after any collision to apply to player.
	motion = move_and_slide(motion)
	
	# Toggles animations to play on key press.
	if Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
		$AnimationPlayer.play("Walk_Left");

	elif Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
		$AnimationPlayer.play("Walk_Right");


	if Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_left"):
			$AnimationPlayer.play("Walk_Upleft");

		elif Input.is_action_pressed("ui_right"):
			$AnimationPlayer.play("Walk_Upright");

		else:
			$AnimationPlayer.play("Walk_Up");


	if Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_left"):
			$AnimationPlayer.play("Walk_Downleft");

		elif Input.is_action_pressed("ui_right"):
			$AnimationPlayer.play("Walk_Downright");

		else:
			$AnimationPlayer.play("Walk_Down");
		
