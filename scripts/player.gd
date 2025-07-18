extends CharacterBody2D 
@onready var ray_castright: RayCast2D = $RayCastright
@onready var ray_castleft: RayCast2D = $RayCastleft

var can_jump = false
var can_dash = false
var can_walljump=false

const SPEED = 450.0
const JUMP_VELOCITY = -1100.0
const WALL_JUMP_VELOCITY = Vector2(600, -1250)

var is_dashing := false
var is_walljumping:=false
var is_jumping=false
var dash_duration := 1  # in seconds
var dash_cooldown := 1  # in seconds
var dash_time_left := 0.0
var dash_cooldown_left := 0.0
var dash_direction
var dash_speed := 1200.0

var wall_dir := 0  # -1 = left wall, 1 = right wall

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta *2
	else:
		velocity.y = 0  # Reset Y velocity when on floor

	# Wall detection
	var on_left_wall = ray_castright.is_colliding()
	var on_right_wall = ray_castleft.is_colliding()
	var on_wall = (on_left_wall or on_right_wall) and not is_on_floor()
	wall_dir = -1 if on_left_wall else (1 if on_right_wall else 0)

	# Handle jumping
	var direction := Input.get_axis("ui_left", "ui_right")
	var prevelocity=WALL_JUMP_VELOCITY.x * -wall_dir 
	if Input.is_action_just_pressed("ui_accept"):
		prevelocity=-1*prevelocity
		if is_on_floor() and can_jump:
			is_jumping=true
			velocity.y = JUMP_VELOCITY
		elif on_wall and can_walljump and direction*prevelocity>0:
			# Wall Jump
			is_walljumping=true
			velocity.y = WALL_JUMP_VELOCITY.y
			
			velocity.x = prevelocity # Jump away from wall
	
	# Horizontal movement
	
	if not is_dashing and  (not  is_walljumping or is_on_floor() or is_jumping)  :
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Dash cooldown logic
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
		# Start dash when "dash" input is pressed
		if Input.is_action_just_pressed("dash") and direction != 0 and can_dash and dash_cooldown_left <= 0:
			is_dashing = true
			dash_direction = direction
			dash_time_left = dash_duration

	# Move the player
	move_and_slide()
