extends CharacterBody2D

var can_jump=false
var can_dash=false
const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var is_dashing := false
var dash_duration := 1  # in seconds
 
var dash_cooldown := 1  # in seconds
var dash_time_left := 0.0
var dash_cooldown_left := 0.0

var dash_direction 
var dash_speed := 1000.0

 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


# Movement speed variables


	# Get input direction
	

	# Dash cooldown timer
	if dash_cooldown_left > 0:
		dash_cooldown_left -= delta

	# Handle dashing
	if is_dashing:
		velocity.x = dash_direction * dash_speed
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false
			dash_cooldown_left = dash_cooldown
	else:
		velocity.x = direction * SPEED
		# Start dash when Shift is pressed
		if Input.is_action_just_pressed("dash") and direction!=0 and can_dash  and dash_cooldown_left <= 0:
			is_dashing = true
			dash_direction = direction
			dash_time_left = dash_duration


	move_and_slide()
