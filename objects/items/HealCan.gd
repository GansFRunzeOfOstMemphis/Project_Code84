extends KinematicBody2D

var velocity = Vector2()
var floor_velocity = Vector2.UP
var health = 24

func _ready():
	pass

func start(_pos):
	position = _pos

func _physics_process(delta):
	velocity.y += 50
	move_and_slide(velocity, floor_velocity)


func _on_Area2D_body_entered(body):
	if body.has_method("char_heal"):
		if body.health_points < body.max_health:
			body.char_heal(health)
			queue_free()
