extends KinematicBody2D

export var speed = 30
export var health_points = 24

var velocity = Vector2()
var grav = Vector2.UP
var i
var direction
var is_moving = false

func movement():
	if is_moving:
		if $WalkingTimer.is_stopped():
			$WalkingTimer.start(0)
			velocity.x = speed * direction
			$AnimatedSprite.play("walking")
			$AnimatedSprite.flip_h = velocity.x < 0
	else:
		if $StandingTimer.is_stopped():
			$StandingTimer.start(0)
			velocity.x = 0
func turning():
	if not $CollisionShape2D/FloorChecker.is_colliding() and is_on_floor():
		direction = direction * -1
		velocity.x = speed * direction
		
	elif not $CollisionShape2D/FloorChecker2.is_colliding() and is_on_floor():
		direction = direction * -1
		velocity.x = speed * direction
		
	if $CollisionShape2D/WallChecker.is_colliding() and is_on_floor():
		direction = direction * -1
		velocity.x = speed * direction
		$AnimatedSprite.flip_h = velocity.x < 0
func enemy_damage(amount):
	health_points -= amount
	if health_points <= 0:
		kill()

func kill():
	pass

func _physics_process(delta):
	movement()
	turning()
	velocity.y += 20
	velocity = move_and_slide(velocity, grav)


func _on_StandingTimer_timeout():
	is_moving = true
	i = randi() % 2
	if i == 0:
		direction = -1
	else:
		direction = 1
	velocity.x = speed * direction
	$AnimatedSprite.play("walking")
	$AnimatedSprite.flip_h = velocity.x < 0

func _on_WalkingTimer_timeout():
	is_moving = false
	$AnimatedSprite.play("idle")
	velocity.x = 0

func _on_InvulnerabilityTimer_timeout():
	pass # Replace with function body.
