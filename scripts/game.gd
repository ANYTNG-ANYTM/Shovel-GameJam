extends Node2D
@onready var player: CharacterBody2D = $player


var ropes := []  # Will hold references to all ropes
var current_rope: Node2D = null
var rope_sprite: Sprite2D = null

var is_swinging := false
var rope_length := 1000.0
var rope_angle := PI / 2
var swing_speed := 1.5

const SWING_DISTANCE := 10000.0  # max distance to attach to rope

func _ready():
	# Get all ropes (you can also group them using a group called "ropes")
	for child in get_children():
		if child.name.begins_with("Rope"):
			ropes.append(child)

func _physics_process(delta):
	if is_swinging and current_rope:
		# Update rope angle (basic swing)
		rope_angle += sin(Time.get_ticks_msec() / 500.0) * delta * swing_speed
		
		var anchor = current_rope.global_position
		var offset = Vector2(cos(rope_angle), sin(rope_angle)) * rope_length
		player.global_position = anchor + offset
		
		# Update the current rope's sprite
		if rope_sprite:
			var start = anchor
			var end = player.global_position
			rope_sprite.global_position = (start + end) / 2.0
			rope_sprite.rotation = (end - start).angle()
			if rope_sprite.texture:
				var height = rope_sprite.texture.get_height()
				rope_sprite.scale.y = (end - start).length() / height

func _input(event):
	if event.is_action_pressed("swing_start"):
		# Find nearest rope within range
		var nearest = null
		var min_dist = SWING_DISTANCE
		

		for rope in ropes:
			if rope:
				print(rope)
				var dist = rope.global_position.distance_to(player.global_position)
				if dist < min_dist:
					nearest = rope
					min_dist = dist

		if nearest:
			current_rope = nearest
			rope_sprite = nearest.get_node("RopeSprite")  # adjust if nested
			is_swinging = true
			rope_angle = PI / 2  # Reset or calculate based on angle
		else:
			print("No rope nearby to swing!")

	if event.is_action_pressed("swing_stop"):
		is_swinging = false
		current_rope = null
		rope_sprite = null
