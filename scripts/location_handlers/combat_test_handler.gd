extends Node2D

var game = null
var combat_spawns = [
	"Point6",
	"Point10",
	"Point23",
	"Point20"
]

var enemy_scene = preload("res://scenes/enemy_ground.tscn")

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
		while i < 7:
			var enemy = enemy_scene.instantiate()
			enemy.always_sees_player = true
			enemy.inaccuracy = 10
			
			var random_point = game.get_node("Waypoints/" + combat_spawns[randi_range(0, combat_spawns.size() - 1)])
			
			enemy.global_position = random_point.global_position
			
			game.get_node("Enemies").add_child(enemy)
