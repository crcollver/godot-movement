# Reference: https://www.youtube.com/watch?v=BeSJgUTLmk0
extends KinematicBody2D
export (PackedScene) var Projectile

const MAX_SPEED = 150
const ACCELERATION = 2000
var facing = Vector2()
var motion = Vector2.ZERO
var mouse_angle = 0

# http://kidscancode.org/godot_recipes/2d/8_direction/
func map_angle_to_index(angle):
	var stepped_angle = stepify(angle, PI/4) / (PI / 4)
	return wrapi(int(stepped_angle), 0, 8)

func get_input_axis():
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

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

func play_walk_animation():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	var direction = get_input_axis()
	
	# Only change the animation if an input key has been pressed.
	# Otherwise the animation would always default to right facing.
	if LEFT || RIGHT || UP || DOWN:
		facing = direction
		
	var animation = "walk_" + str(map_angle_to_index(facing.angle()))
	if($AnimationPlayer.assigned_animation != animation):
		$AnimationPlayer.play(animation)

func shoot():
	var mouse = get_local_mouse_position()
	$AnimationPlayer.play("walk_" + str(map_angle_to_index(mouse.angle())))
	
	var projectile = Projectile.instance()
	owner.add_child(projectile)
	$Pivot.look_at(get_global_mouse_position())
	projectile.transform = $Pivot/ProjectileSpawner.global_transform

func _physics_process(delta):
	var axis = get_input_axis()
	
	# If there is no movement vector, apply friction to stop player.
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)

	motion = move_and_slide(motion)
	
func _process(_delta):
	# Until we add an AnimationTree, the walk animation changes back too fast after shooting.
	# play_walk_animation()
	
	if Input.is_action_just_pressed("player_shoot"):
		shoot()
