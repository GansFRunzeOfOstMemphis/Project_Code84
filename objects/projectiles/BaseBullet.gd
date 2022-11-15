extends KinematicBody2D

var dmg = 12
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
	if body.get_name() == "MainCharacter":
		body.char_damage(dmg)
		queue_free()
	elif body.get_name() == "EnemySoldier":
		pass
	else:
		queue_free()
