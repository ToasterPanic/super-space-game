extends Node2D

var chunk_tick_timer = 0
var chunks = {}
var chunk_process_distance = 6
var time_since_last_atmospheric_track = 999
var current_atmospheric_track = null
var combat = false
var combat_track = null

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")
var star_scene = preload("res://scenes/star.tscn")

@onready var spawn_points = {
	"space_station_1": $Orbits/SpaceStation1/space_station_1/ExitPoint,
	"space_station_2": $Orbits/SpaceStation2/space_station_2/ExitPoint
}

@onready var navigation_points = [
	{
		"name": "Space Station 01",
		"id": "ss1",
		"point": $Orbits/SpaceStation1/space_station_1
	},
	{
		"name": "Space Station 02",
		"id": "ss2",
		"point": $Orbits/SpaceStation2/space_station_2
	}
]

func ship_health(health: float = 1000) -> void:
	$Player.health = health
	
func summon_enemy() -> void:
	var spawn_position = $Player.position + ($Player.transform.y * 1024)
	
	var enemy = enemy_scene.instantiate() 
	enemy.position = spawn_position
	
	$Enemies.add_child(enemy)

## Takes a world coordinate and converts it to a chunk coordinate.
func world_to_chunk(position: Vector2) -> Vector2:
	return Vector2(floori(position.x / 1024), floori(position.y / 1024))
	
## Takes a chunk coordinate and converts it to a world coordinate.
func chunk_to_world(position: Vector2) -> Vector2:
	return Vector2(floori(position.x * 1024), floori(position.y * 1024))
	
## Saves the game.
func save_game() -> void:
	$UI/Control/SaveIndicator.visible = true
	
	global.stats.position = {
		"x": $Player.global_position.x,
		"y": $Player.global_position.y
	}
	
	global.stats.location = "space"
	
	global.save_game()
	
	await get_tree().create_timer(2).timeout
	
	$UI/Control/SaveIndicator.visible = false
	
func enter_physical(map):
	get_tree().paused = true
	
	var i = 0
	while i < 5:
		$UI/FadeToBlack.modulate.a = (i/5.0)
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/FadeToBlack.modulate.a = 1
	
	await get_tree().create_timer(0.4).timeout
	
	get_tree().paused = false
	
	global.stats.location = map
	
	global.stats.position = null
	
	get_tree().change_scene_to_file("res://scenes/ground.tscn")
		
		
func _ready() -> void:
	LimboConsole.register_command(ship_health, "ship_health", "Sets the ship's health.")
	LimboConsole.register_command(summon_enemy, "summon_enemy", "Summons an enemy.")
	
	var events = InputMap.action_get_events("forward")
		
	for n in navigation_points:
		var navigation_item = preload("res://scenes/navigation_item.tscn").instantiate()
		
		navigation_item.goal = n
		navigation_item.game = self
		
		$UI/Control/Navpanel/NavigationRoutes/Scroll/Box.add_child(navigation_item)
		
	for n in global.contracts:
		var contract_item = preload("res://scenes/contract_item.tscn").instantiate()
		
		contract_item.contract = n
		contract_item.game = self
		
		$UI/Control/Navpanel/ContractsList/Scroll/Box.add_child(contract_item)
		
	var i = 0
	while i < 1024 / 3:
		var star = star_scene.instantiate() 
		star.position = Vector2(-99999999999999999, -9999999999999999999)
		
		$Stars.add_child(star)
		
		i += 1
		
	i = 0
	while i < 1024 / 3:
		var star = star_scene.instantiate() 
		star.position = Vector2(-99999999999999999, -9999999999999999999)
		star.parallax = 0.2
		
		$Stars.add_child(star)
		
		i += 1
		
	i = 0
	while i < 1024 / 3:
		var star = star_scene.instantiate() 
		star.position = Vector2(-99999999999999999, -9999999999999999999)
		star.parallax = 0.5
		
		$Stars.add_child(star)
		
		i += 1
		
	if (global.stats.location != "space") and (spawn_points.has(global.stats.location)):
		$Player.global_position = spawn_points[global.stats.location].global_position
		$Player.rotation = spawn_points[global.stats.location].rotation
	elif global.stats.position:
		$Player.global_position.x = global.stats.position.x
		$Player.global_position.y = global.stats.position.y
		
		global.stats.position = null
	
	global.stats.location = "space"
	
	if global.stats.story_progress < 4: global.stats.story_progress = 4
	
	if global.stats.loaded:
		save_game()
	else:
		global.stats.loaded = true

func _process(delta: float) -> void:
	if get_tree().paused:
		return
		
	
		
	if global.stats.navigation_goal:
		if !global.stats.navigation_goal.point || (typeof(global.stats.navigation_goal.point) == TYPE_STRING):
			if global.stats.navigation_goal.id:
				for n in navigation_points:
					if n.id == global.stats.navigation_goal.id:
						global.stats.navigation_goal.point = n.point 
						break
		else:
			if !$Navring.has_node("NavigationMarker"):
				var navigation_marker = preload("res://scenes/navigation_marker.tscn").instantiate()
				
				navigation_marker.destination = global.stats.navigation_goal.point
				
				$Navring.add_child(navigation_marker)
				
			if $UI/Control/Navpanel/NavigationHyperboost.visible:
				var distance_to_hyperboost = (global.stats.navigation_goal.point.global_position - $Player.global_position).length() - 3000
				var fuel_cost = floori((distance_to_hyperboost / 4096) * 7)
				
				$UI/Control/Navpanel/NavigationHyperboost/FuelRequired.text = "FUEL REQUIRED:\n"+ str(fuel_cost) + "%"
				
			if $UI/Control/Navpanel/Navigation.visible:
			
				$UI/Control/Navpanel/Navigation/CurrentRoute.visible = true
				$UI/Control/Navpanel/Navigation/Destination.visible = true
				
				$UI/Control/Navpanel/Navigation/Hyperboost.visible = true
				
				if global.stats.navigation_goal.point and (typeof(global.stats.navigation_goal.point) != TYPE_STRING):
					var goal_distance = (global.stats.navigation_goal.point.position - $Player.position).length()
				
					$UI/Control/Navpanel/Navigation/Destination.text = global.stats.navigation_goal.name + " (" + str(floori(goal_distance)) + "u)"
	else:
		if $Navring.has_node("NavigationMarker"):
			$Navring.get_node("NavigationMarker").queue_free()
			
		if $UI/Control/Navpanel/Navigation.visible:
			$UI/Control/Navpanel/Navigation/CurrentRoute.visible = false
			$UI/Control/Navpanel/Navigation/Destination.visible = false
				
			$UI/Control/Navpanel/Navigation/Hyperboost.visible = false
	
	if $UI/Control/Navpanel/Start.visible:
		$UI/Control/Navpanel/Start/Fuel.value = global.stats.fuel
		$UI/Control/Navpanel/Start/Fuel/Label.text = str(roundi(global.stats.fuel)) + "%"
		
	if $UI/Control/Navpanel/NavigationRoutes.visible:
		for n in $UI/Control/Navpanel/NavigationRoutes/Scroll/Box.get_children():
			n.update()
	
	$Navring.position = $Player.position
	
	if current_atmospheric_track:
		if not current_atmospheric_track.playing:
			time_since_last_atmospheric_track = 0
	else:
		time_since_last_atmospheric_track += delta
		
		if time_since_last_atmospheric_track > 60:
			var tracks = [$BalladOfTheCats, $ConcreteHalls]
			
			current_atmospheric_track = tracks[randi_range(0, tracks.size() - 1)]
			current_atmospheric_track.play()
	
	chunk_tick_timer -= delta
	
	if chunk_tick_timer < 0:
		chunk_tick_timer = 0.5
		
		var player_chunk = world_to_chunk($Player.position)
		
		var valid_chunks = []
		
		var x_mod = -chunk_process_distance
		
		while x_mod <= chunk_process_distance:
			var y_mod = -chunk_process_distance
			
			while y_mod <= chunk_process_distance:
				var chunk_position = Vector2(player_chunk.x - x_mod, player_chunk.y - y_mod)
				
				valid_chunks.push_front(chunk_position)
				
				if !chunks.has(chunk_position):
					chunks[chunk_position] = {
						"loaded": true,
						"time_to_unload": 0,
					}
					
					var world_position = chunk_to_world(chunk_position)
					var orbit_zone = null
					for n in global.orbit_zones:
						
						if world_position.length() < n.distance:
							continue
						orbit_zone = n
						
					for n in orbit_zone.spawns:
						var i = 0
						
						while i < n.amount_min:
							var asteroid = asteroid_scene.instantiate()
						
							asteroid.rotation = randf_range(-5.0, 5.0)
							asteroid.position = chunk_to_world(chunk_position) + Vector2(randi_range(0, 1024), randi_range(0, 1024))
							
							$Unloadables.add_child(asteroid)
							
							i += 1
					
				y_mod += 1
				
			x_mod += 1
			
		for n in chunks.keys():
			if !valid_chunks.has(n):
				chunks.erase(n)
				
		for n in $Unloadables.get_children():
			var n_pos = world_to_chunk(n.position)
			if abs(n_pos.x - player_chunk.x) > chunk_process_distance:
				n.queue_free()
			elif abs(n_pos.y - player_chunk.y) > chunk_process_distance:
				n.queue_free()
				
		# Just gonna put the combat check in here too
		combat = false 
		
		for n in $Enemies.get_children():
			if "ai_mode" in n:
				if n.ai_mode == n.AI_MODE_ATTACK:
					combat = true
					
		$UI/Control/CombatIndicator.visible = combat
					
		if combat:
			if !combat_track:
				var combat_tracks = $CombatMusic.get_children()
				
				combat_track = combat_tracks[randi_range(0, combat_tracks.size() - 1)]
				
				combat_track.play()
		else:
			if combat_track:
				combat_track.stop()
				
				combat_track = null
				
func _set_navpanel_menu(menu: String) -> void:
	for n in $UI/Control/Navpanel.get_children():
		if n.get_name() == menu:
			n.visible = true
			
			if menu == "NavigationRoutes":
				n.get_node("Scroll/Box").get_children()[0].get_node("Button").grab_focus()
			else:
				for o in n.get_children():
					if o.is_class("Button"):
						o.grab_focus()
						break
		else:
			n.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$UiSelect.play()
		
		$UI/Control/PauseMenu.visible = true
		
		$UI/Control/PauseMenu/Panel/Flow/Resume.grab_focus()
		
		get_tree().paused = true
	elif event.is_action_pressed("navpanel"):
		if $UI/Control/Navpanel.visible:
			$UiBack.play()
			
			$UI/Control/Navpanel.visible = false
		else:
			$UiSelect.play()
			
			$UI/Control/Navpanel.visible = true
			
			_set_navpanel_menu("Start")
	elif event.is_action_pressed("ui_back"):
		if $UI/Control/Navpanel.visible:
			$UiBack.play()
			
			if ($UI/Control/Navpanel/NavigationRoutes.visible) or ($UI/Control/Navpanel/NavigationHyperboost.visible):
				_set_navpanel_menu("Navigation")
			elif $UI/Control/Navpanel/ContractsList.visible:
				_set_navpanel_menu("Contracts")
			elif $UI/Control/Navpanel/Start.visible:
				$UI/Control/Navpanel.visible = false
			else:
				_set_navpanel_menu("Start")


func _on_tree_exiting() -> void:
	LimboConsole.unregister_command(ship_health)
	LimboConsole.unregister_command(summon_enemy)


func _on_navigation_pressed() -> void:
	$UiSelect.play()
	_set_navpanel_menu("Navigation")


func _on_navpanel_back_pressed() -> void:
	$UiBack.play()
	_set_navpanel_menu("Start")


func _on_new_route_pressed() -> void:
	$UiSelect.play()
	_set_navpanel_menu("NavigationRoutes")


func _on_cancel_route_pressed() -> void:
	$UiSelect.play()
	global.stats.navigation_goal = null


func _on_quit_pressed() -> void:
	$UiBack.play()
	$UI/Control/Navpanel.visible = false


func _navigation_item_pressed(goal) -> void:
	global.stats.navigation_goal = goal
	$UiSelect.play()
	_set_navpanel_menu("Navigation")

func _contracts_item_pressed(contract) -> void:
	if global.stats.active_mission: return 
	
	global.stats.active_mission = contract 
	global.stats.mission_progress = 0
	
	$UiSelect.play()
	_set_navpanel_menu("Contracts")


func _on_navigation_back_pressed() -> void:
	$UiBack.play()
	_set_navpanel_menu("Navigation")


func _on_hyperboost_pressed() -> void:
	$UiSelect.play()
	_set_navpanel_menu("NavigationHyperboost")


func _on_enable_hyperboost_pressed() -> void:
	$UiSelect.play()
	_set_navpanel_menu("Navigation")
	$Player.hyperboosting = true

func _on_new_contract_pressed() -> void:
	$UiSelect.play()
	_set_navpanel_menu("ContractsList")

func _on_contracts_pressed() -> void:
	$UiSelect.play()
	_set_navpanel_menu("Contracts")
	
func _on_contracts_back_pressed() -> void:
	$UiBack.play()
	_set_navpanel_menu("Contracts")
