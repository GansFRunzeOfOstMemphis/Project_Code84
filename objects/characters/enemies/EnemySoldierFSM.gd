extends StateMachine
	
func _ready():
	add_state("idle")
	add_state("moving")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent.logic_move()
	parent.turning()
	parent._apply_gravity()
	parent._apply_movement()
	parent.targeting(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if parent.velocity.x != 0:
				return states.moving
		states.moving:
			if parent.velocity.x == 0:
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_sprite.play("idle")
		states.moving:
			parent.anim_sprite.play("walking")
