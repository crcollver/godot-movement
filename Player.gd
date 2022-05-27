# Reference: https://www.youtube.com/watch?v=BeSJgUTLmk0
extends KinematicBody2D

const MAX_SPEED = 500
const ACCELERATION = 2000
var motion = Vector2.ZERO

func get_input_axis():
	var axis = Vector2.ZERO

	# One side will be "1" or "0", so movement to the right is +1, movement left is -1.
	# I do not like the casting to int here though.
	var right = int(Input.is_action_pressed("ui_right")) 
	var left = int(Input.is_action_pressed("ui_left"))
	axis.x =  right - left

	# Same principle applies for y.
	var down = int(Input.is_action_pressed("ui_down")) 
	var up = int(Input.is_action_pressed("ui_up"))
	axis.y =  down - up
	
	# A vector math thing?
	# If vector isn't normalized, then diagonal directions would make player move faster.
	return axis.normalized()

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
