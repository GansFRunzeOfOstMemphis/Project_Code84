extends KinematicBody2D #Ну что, начнем?
#Это код, отвечающий за персонажа, которым мы управляем

#Все изначальные параметры, переменные, константы и пр.
export var speed = 180
var velocity = Vector2()
var gravity = 8
var jump_speed = 280
const floor_velocity = Vector2(0, -1)

#Функция (в C# здесь был бы метод), отвечающая за перемещение персонажа (а также его физику)
func _physics_process(delta):
	#При нажатии заранее прописаных в настройках проекта кнопок - 
	#персонаж передвигается
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	#Стандартный прыжок в высоту, превышающую рост персонажа в 3 раза
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = -jump_speed
	
	#"Гравитация" персонажа. Может быть полезным в будущем изменять ее при желании
	velocity.y += gravity
	velocity = move_and_slide(velocity, floor_velocity)
