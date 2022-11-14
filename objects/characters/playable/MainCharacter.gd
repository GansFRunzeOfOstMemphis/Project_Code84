extends KinematicBody2D #Ну что, начнем?
#Это код, отвечающий за персонажа, которым мы управляем

#Все изначальные параметры, переменные, константы и пр.
#
signal health_change(health_points)
signal stamina_change(stamina_points)
signal killed()

#Данные на экспорт
export var speed = 180
export var jump_speed = 300
export var max_health = 60
export var max_stamina = 100
var stamina_regen = 5

onready var health_points = 60
onready var stamina_points = 100
onready var anim_sprite = $AnimatedSprite

#Данные, отвечающие за правильное перемещение персонажа в мире
var velocity = Vector2()
var dash_velocity = Vector2.ZERO

const floor_velocity = Vector2(0, -1)
const UP_DIR := Vector2.UP
const slope_stop = 30

var gravity = 540

var is_dashing = false
var is_dash_avaliable = true
var is_invulnerable = false

var is_moving
var target = position
#

#Основная функция, определяющая движение
#(Здесь происходит взаимодействие всех остальных функций движения)

func _apply_gravity(delta):
	velocity.y += gravity * delta 
	
func _apply_dash():
	if is_dashing:
		velocity = move_and_slide(dash_velocity, UP_DIR)
		if position.distance_to(target) < 0:
			is_dashing = false
	
func _apply_movement():
	velocity = move_and_slide(velocity, floor_velocity, slope_stop)
	
	
func _handle_move_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, speed * move_direction, _get_h_weight())
	if move_direction != 0:
		is_moving = true
		$Body.scale.x = move_direction
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		is_moving = false

func _get_h_weight():
	return 0.2 
#Рывок персонажа по направлению курсора
func dash():
	if is_dash_avaliable:
		if Input.is_action_pressed("mouse_right_click"):
			$DashLine.set_point_position(1,self.position)
			$DashLine.set_point_position(1,(get_global_mouse_position() - self.global_position).limit_length(100)*2)
			$DashLine.visible = true
		if Input.is_action_just_released("mouse_right_click"):
			is_dash_avaliable = false
			is_dashing = true
			target = get_global_mouse_position()
			dash_velocity = move_and_slide(get_global_mouse_position() - self.global_position).limit_length(150)*2
			$DashTimer.start(0) 
			$DashCDTimer.start(0)
			$DashLine.visible = false
	
#Получение персонажем урона
func char_damage(amount):
		if is_invulnerable == false:
			is_invulnerable = true
			health_points -= amount
			emit_signal("health_change", health_points)
			
			$InvulnerabilityTimer.start(0)
			if health_points <= 0:
				kill()

func char_heal(amount):
	if health_points < max_health:
		health_points += amount
		health_points = min(health_points, max_health)
		emit_signal("health_change", health_points)

func stamina_lose(amount):
	stamina_points -= amount
	emit_signal("stamina_change", stamina_points)

func stamina_gain(amount):
	if stamina_points < max_stamina:
		stamina_points += amount
		stamina_points = min(stamina_points, max_stamina)
		emit_signal("stamina_change", stamina_points)

func regenerate_stm():
	stamina_gain(stamina_regen)

#Функция "убийства" персонажа
func kill():
	pass

func _on_DashTimer_timeout():
	is_dashing = false

func _on_DashCDTimer_timeout():
	is_dash_avaliable = true

func _on_InvulnerabilityTimer_timeout():
	is_invulnerable = false
