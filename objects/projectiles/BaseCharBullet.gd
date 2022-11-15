extends KinematicBody2D

var dmg = 8
var speed = 300
var target
var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta

func start(_pos, _dir):
	position = _pos
	rotation = _dir.angle()
	velocity = _dir * speed


func _on_Area2D_body_entered(body):
	if body.has_method("is_enemy"):
		body.enemy_damage(dmg)
		queue_free()
	elif body.get_name() == "MainCharacter":
		pass
	else:
		queue_free()
