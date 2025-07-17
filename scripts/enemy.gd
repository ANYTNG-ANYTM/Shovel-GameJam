extends Node2D
const SPEED=500
@onready var ray_castright: RayCast2D = $RayCastright
@onready var ray_castleft: RayCast2D = $RayCastleft

var direction=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_castright.is_colliding():
		direction=-1
	if ray_castleft.is_colliding():
		direction=1
	position.x += SPEED * delta * direction
