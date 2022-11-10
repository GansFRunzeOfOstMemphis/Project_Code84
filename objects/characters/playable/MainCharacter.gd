extends KinematicBody2D #Ну что, начнем?
#Это код, отвечающий за персонажа, которым мы управляем

#Все изначальные параметры, переменные, константы и пр.
#
signal health_change(health_points)
signal max_health_change(max_health)
signal killed()

#Данные на экспорт
export var speed = 180
export var jump_speed = 300
export var jump_counter = 1
export var max_health = 60
export var health_regeneration = 0

onready var health_points = max_health setget _set_health

#Данные, отвечающие за правильное перемещение персонажа в мире
var velocity = Vector2()
var dash_velocity = Vector2.ZERO

const floor_velocity = Vector2(0, -1)
const UP_DIR := Vector2.UP
const slope_stop = 30

var gravity = 540

var is_dashing = false
var is_dash_avaliable = true

var target = position
#

#Основная функция, определяющая движение
#(Здесь происходит взаимодействие всех остальных функций движения)
func _physics_process(delta):
	get_input()	
	dash()
	
	velocity.y += gravity * delta 
	
	if is_dashing:
		velocity = move_and_slide(dash_velocity, UP_DIR)
		if position.distance_to(target) < 0:
			is_dashing = false
	velocity = move_and_slide(velocity, floor_velocity, slope_stop)
	
	
#Базовое управление: движение вперёд-назад, прыжок
func get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, speed * move_direction, _get_h_weight())
	if move_direction != 0:
		$Body.scale.x = move_direction

func _input(event):
	if event.is_action_pressed("move_jump") && is_on_floor():
		velocity.y -= jump_speed
#Функция проверки, находится ли персонаж "на полу"

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
func damage(amount):
	if $InvulnerabilityTimer.is_stopped():
		$InvulnerabilityTimer.start()
		_set_health(health_points - amount)

#Функция "убийства" персонажа
func kill():
	pass

#Функция фиксирования изменений здоровья персонажа
func _set_health(value):
	var prev_health = health_points
	health_points = clamp(value, 0, max_health)
	if health_points != prev_health:
		emit_signal("health_change", health_points)
		if health_points == 0:
			kill()
			emit_signal("killed")
	

func _on_DashTimer_timeout():
	is_dashing = false

func _on_DashCDTimer_timeout():
	is_dash_avaliable = true

func _on_InvulnerabilityTimer_timeout():
	pass 
