extends Area2D

var target = null

func can_see_player():
	return target 

func _on_DetectRadius_body_entered(body):
	if target == null and body.get_name() == "MainCharacter":
		target = body

func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
