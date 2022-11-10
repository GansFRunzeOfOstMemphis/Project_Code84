extends CanvasLayer

onready var health_bar = $HealthBar

func _on_MainCharacter_health_change(health_points):
	health_bar.value = health_points
