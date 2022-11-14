extends StaticBody2D
var dmg = 12
func _on_Area2D_body_entered(body):
	if body.has_method("char_damage"):
		body.char_damage(dmg)
	
