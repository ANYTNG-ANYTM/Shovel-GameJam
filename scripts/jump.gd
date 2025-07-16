
extends Area2D


func _on_body_entered(body):
	if body.name == "player":
		body.can_jump = true
		print("Jump enabled!") 
