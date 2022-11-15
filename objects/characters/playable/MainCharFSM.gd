extends StateMachine #StateMachine персонажа

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)

func _input(event):
	if[states.idle, states.run].has(state):
		if event.is_action_pressed("move_jump"):
			parent.velocity.y -= parent.jump_speed

func _state_logic(delta):
	parent._handle_move_input()
	parent.regenerate_stm()
	parent.dash()
	parent._apply_dash()
	parent._apply_gravity(delta)
	parent._apply_movement()
	parent.targeting(delta)
	parent.send_stats()

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_sprite.play("idle")
		states.run:
			parent.anim_sprite.play("moving")
		states.jump:
			parent.anim_sprite.play("jump")
		states.fall:
			parent.anim_sprite.play("fall")


