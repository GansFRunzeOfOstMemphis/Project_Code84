extends KinematicBody2D

signal shoot(pro, _pos, _dir)
signal drop_item(pro, _pos)
export var speed = 30
export var health_points = 24

const bullet = preload("res://objects/projectiles/BaseBullet.tscn")
const heal_can = preload("res://objects/items/HealCan.tscn")

var detect_radius = 100
var aim_speed = 60

var velocity = Vector2()
var grav = Vector2.UP
var i
var direction = 1

var is_moving = false
var is_invulnerable = false
var target = null
var can_shoot = true
var ready_to_shoot = false
onready var anim_sprite = $AnimatedSprite
	
func is_enemy():
	pass

func logic_move():
	if is_moving:
		if $WalkingTimer.is_stopped():
			$WalkingTimer.start(0)
			velocity.x = speed * direction
	else:
		if $StandingTimer.is_stopped():
			$StandingTimer.start(0)
			velocity.x = 0

func random_direction_movement():
	if is_moving:
		i = randi() % 2
		if i == 0:
			direction = -1
		else:
			direction = 1
	movement()

func movement():
		velocity.x = speed * direction
		anim_sprite.flip_h = velocity.x < 0

func _apply_gravity():
	velocity.y += 20
	
func _apply_movement():
	velocity = move_and_slide(velocity, grav)
	
func turning():
	if not $CollisionShape2D/FloorChecker.is_colliding() and is_on_floor():
		direction = direction * -1
		movement()
		
	elif not $CollisionShape2D/FloorChecker2.is_colliding() and is_on_floor():
		direction = direction * -1
		movement()
		
	if $CollisionShape2D/WallChecker.is_colliding() and is_on_floor():
		direction = direction * -1
		movement()
	
func targeting(delta):
	if target != null:
		var target_dir = (target.global_position - self.global_position).normalized()
		var current_dir = Vector2(1,0).rotated($ShootLine.global_rotation)
		$ShootLine.global_rotation = current_dir.linear_interpolate(target_dir,aim_speed * delta).angle()
		#$ShootLine.set_point_position(1,self.position)
		#$ShootLine.set_point_position(1,(target.global_position - self.global_position).limit_length(12))
		if can_shoot and !is_moving: 
			shoot_projectile()
	
func shoot_projectile():
		#$AnimatedSprite.play("attack")
		var dir = Vector2(1,0).rotated($ShootLine/Position2D.global_rotation)
		emit_signal("shoot", bullet, $ShootLine/Position2D.global_position, dir)
		$ShootTimer.start(0)
		$FireTimer.start(0)
		can_shoot = false

func enemy_damage(amount):
	if is_invulnerable == false:
		is_invulnerable = true
		health_points -= amount
		
		$InvulnerabilityTimer.start(0)
		
		if health_points <= 0:
			kill()

func kill():
	var j = randi() % 3
	if j == 0:
		emit_signal("drop_item", heal_can, global_position)
	else:
		pass
	queue_free()

func _on_StandingTimer_timeout():
	ready_to_shoot = false
	is_moving = true
	random_direction_movement()
	movement()
	
func _on_WalkingTimer_timeout():
	is_moving = false
	velocity.x = 0

func _on_InvulnerabilityTimer_timeout():
	is_invulnerable = false

func _on_ShootTimer_timeout():
	can_shoot = true


func _on_Area2D_body_entered(body):
	if body.get_name() == "MainCharacter":
		$TestLabel.text = "I see target"
		target = body


func _on_Area2D_body_exited(body):
	if target == body:
		$TestLabel.text = "Can't see target"
		target = null


func _on_FireTimer_timeout():
	if velocity.x != 0:
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("idle")
