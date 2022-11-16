extends Node2D
var random_room1 = preload("res://objects/rooms/Room1.tscn")
var random_room2 = preload("res://objects/rooms/Room2.tscn")
var item = null

func _ready():
	$Menu.hide()
	randomize()
	var j = randi() % 2
	if j == 1:
		item = random_room1.instance()
	else:
		item = random_room2.instance()
	add_child(item)
	item.position.x = 672
	item.position.y = 192

func _on_EnemySoldier_shoot(pro, _pos, _dir):
	var i = pro.instance()
	self.add_child(i)
	i.start(_pos, _dir)

func _on_MainCharacter_player_shoot(pro, _pos, _dir):
	var i = pro.instance()
	self.add_child(i)
	i.start(_pos, _dir)

func _on_EnemySoldier_drop_item(pro, _pos):
	var i = pro.instance()
	self.add_child(i)
	i.start(_pos)


func _on_QuitZone_body_entered(body):
	if body.get_name() == "MainCharacter":
		$Menu.show()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
	randomize()


func _on_MainCharacter_killed():
	get_tree().reload_current_scene()
	randomize()
