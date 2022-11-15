extends CanvasLayer

onready var health_bar = $HealthBar
onready var health_bar_behind = $HealthBarBehind
onready var stamina_bar = $StaminaBar
onready var update_tween = $UpdateTween
onready var stat_damage = $StatisticsPanel/TextureRect/StatLabelDamage
onready var stat_attack_speed = $StatisticsPanel/TextureRect/StatLabelAttackSpeed
onready var stat_defence = $StatisticsPanel/TextureRect/StatLabelDefense
onready var stat_move_speed = $StatisticsPanel/TextureRect/StatLabelMoveSpeed
onready var stat_jump_speed = $StatisticsPanel/TextureRect/StatLabelJumpSpeed

func _ready():
	$StatisticsPanel.visible = false
	$Inventory.hide()
	health_bar.value = 60
	health_bar_behind.value = 60
	stamina_bar.value = 100
	
func _process(delta):
	if Input.is_action_just_pressed("get_inventory"):
		$StatisticsPanel.visible = true
		$Inventory.show()
	elif Input.is_action_just_pressed("get_cancel"):
		$StatisticsPanel.visible = false
		$Inventory.hide()
	
func _on_MainCharacter_health_change(health_points):
	health_bar.value = health_points
	update_tween.interpolate_property(health_bar_behind, "value", health_bar_behind.value, health_points, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	update_tween.start()

func _on_MainCharacter_stamina_change(stamina_points):
	update_tween.interpolate_property(stamina_bar, "value", stamina_bar.value, stamina_points, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)

func _on_MainCharacter_stats_sent(dmg, atck_spd, def, mv_spd, jmp_spd):
	stat_damage.text = str(dmg)
	stat_attack_speed.text = str(atck_spd) + " sec"
	stat_defence.text = str(def)
	stat_move_speed.text = str(mv_spd)
	stat_jump_speed.text = str(jmp_spd)
