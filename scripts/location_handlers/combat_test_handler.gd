extends Node2D

var game = null
var combat_spawns = [
	"Point6",
	"Point10",
	"Point23",
	"Point20"
]

var enemy_scene = preload("res://scenes/enemy_ground.tscn")

func _random_point():
	var points = game.get_node("Waypoints").get_children()
	return points[randi_range(0, points.size() - 1)]

func _interact(player: CharacterBody2D, area: Node2D):
	var button_name = area.get_parent().get_name()
	
	if button_name == "TeleportIn":
		player.global_position = game.get_node("TeleportOut").global_position
	elif button_name == "TeleportOut":
		player.global_position = game.get_node("TeleportIn").global_position
	elif button_name == "Heal":
		player.health = 100
	elif button_name == "Pistol":
		player.set_ground_gun(null)
		global.stats.equipped_ground_gun = "pistol"
		global.stats.gun_holstered = false
	elif button_name == "Smg":
		player.set_ground_gun(null)
		global.stats.equipped_ground_gun = "smg"
		global.stats.gun_holstered = false
	elif button_name == "SummonCombatEnemies":
		var i = 0
		while i < 4:
			var enemy = preload("res://scenes/enemy_ground.tscn").instantiate()
			enemy.always_sees_player = true
			enemy.inaccuracy = 12
			enemy.speed = 140
			enemy.game = game
			enemy.reaction_time = 0.75
			
			var random_point = game.get_node("Waypoints/" + combat_spawns[randi_range(0, combat_spawns.size() - 1)])
			
			enemy.global_position = random_point.global_position
			enemy.global_position += Vector2(randf_range(-24, 24), randf_range(-24, 24))
			
			print(random_point)
			
			game.get_node("Enemies").add_child(enemy)
			
			i += 1
	elif button_name == "SummonStealthEnemies":
		var i = 0
		while i < 4:
			var enemy = preload("res://scenes/enemy_ground.tscn").instantiate()
			
			enemy.inaccuracy = 9
			enemy.speed = 140
			enemy.game = game
			enemy.reaction_time = 0.566
			
			var random_point = game.get_node("Waypoints/" + combat_spawns[randi_range(0, combat_spawns.size() - 1)])
			
			enemy.global_position = random_point.global_position
			enemy.global_position += Vector2(randf_range(-24, 24), randf_range(-24, 24))
			
			var pointlist: Array[Node2D] = [
				random_point,
				_random_point(),
				_random_point(),
			]
			
			
			
			enemy.points = pointlist
			
			game.get_node("Enemies").add_child(enemy)
			
			i += 1
