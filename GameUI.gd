extends CanvasLayer

onready var health_bar = $HealthBar
onready var health_bar_behind = $HealthBarBehind
onready var stamina_bar = $StaminaBar
onready var update_tween = $UpdateTween

func _ready():
	health_bar.value = 60
	health_bar_behind.value = 60
	stamina_bar.value = 100
	
func _on_MainCharacter_health_change(health_points):
	health_bar.value = health_points
	update_tween.interpolate_property(health_bar_behind, "value", health_bar_behind.value, health_points, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	update_tween.start()

func _on_MainCharacter_stamina_change(stamina_points):
	update_tween.interpolate_property(stamina_bar, "value", stamina_bar.value, stamina_points, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
