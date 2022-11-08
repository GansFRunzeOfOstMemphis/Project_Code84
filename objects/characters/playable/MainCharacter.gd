extends KinematicBody2D #Ну что, начнем?
#Это код, отвечающий за персонажа, которым мы управляем

#Все изначальные параметры, переменные, константы и пр.
export var speed = 180

var jump_counter = 1
var velocity = Vector2()
var dash_velocity = Vector2.ZERO
var gravity = 540
var jump_speed = 300
var is_dashing = false

const floor_velocity = Vector2(0, -1)
const UP_DIR := Vector2.UP

var target = position

func get_input():
	velocity.x = 0
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_just_pressed("move_jump")
	
	if left:
		velocity.x -= speed
	if right:
		velocity.x += speed
	if jump and is_on_floor():
		velocity.y -= jump_speed
	
	if velocity.x != 0:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.flip_h = velocity.x < 0

func dash():
	if Input.is_action_pressed("mouse_right_click"):
		$DashLine.set_point_position(1,self.position)
		$DashLine.set_point_position(1,(get_global_mouse_position() - self.global_position).limit_length(200))
		$DashLine.visible = true
	if Input.is_action_just_released("mouse_right_click"):
		is_dashing = true
		target = get_global_mouse_position()
		dash_velocity = move_and_slide(get_global_mouse_position() - self.global_position).limit_length(100)*2
		$DashTimer.start(0) 
		$DashLine.visible = false
		
	
#"Гравитация" персонажа. Может быть полезным в будущем изменять ее при желании
func _physics_process(delta):
	velocity.y += gravity * delta 
	
	get_input()	
	dash()
	
	if is_dashing:
		velocity = move_and_slide(dash_velocity, UP_DIR)
		if position.distance_to(target) < 0:
			is_dashing = false
	
	velocity = move_and_slide(velocity, floor_velocity)


func _on_DashTimer_timeout():
	is_dashing = false
