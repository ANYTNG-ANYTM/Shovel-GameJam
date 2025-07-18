extends Area2D




func _on_body_entered(body):
	if body.name == "player":
		body.can_walljump = true
		print("Wall Jump enabled!") 
