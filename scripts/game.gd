extends Node2D

var chunk_tick_timer = 0
var chunks = {}
var chunk_process_distance = 6
var time_since_last_atmospheric_track = 999
var current_atmospheric_track = null

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")
var star_scene = preload("res://scenes/star.tscn")

@onready var spawn_points = {
	"SpaceStation1": $Orbits/SpaceStation1/SpaceStation1/ExitPoint
}

func ship_health(health: float = 1000) -> void:
	$Player.health = health
	
func summon_enemy() -> void:
	var spawn_position = $Player.position + ($Player.transform.y * 1024)
	
	var enemy = enemy_scene.instantiate() 
	enemy.position = spawn_position
	
	add_child(enemy)

## Takes a world coordinate and converts it to a chunk coordinate.
func world_to_chunk(position: Vector2) -> Vector2:
	return Vector2(floori(position.x / 1024), floori(position.y / 1024))
	
## Takes a chunk coordinate and converts it to a world coordinate.
func chunk_to_world(position: Vector2) -> Vector2:
	return Vector2(floori(position.x * 1024), floori(position.y * 1024))
	
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
	
	get_tree().change_scene_to_file("res://scenes/ground.tscn")
		
		
func _ready() -> void:
	LimboConsole.register_command(ship_health, "ship_health", "Sets the ship's health.")
	LimboConsole.register_command(summon_enemy, "summon_enemy", "Summons an enemy.")
	
	var events = InputMap.action_get_events("forward")
	
	if (global.stats.location != "space") and (spawn_points.has(global.stats.location)):
		$Player.global_position = spawn_points[global.stats.location].global_position
		$Player.rotation = spawn_points[global.stats.location].rotation
		
	var i = 0
	while i < 512:
		var star = star_scene.instantiate() 
		star.position = Vector2(-99999999999999999, -9999999999999999999)
		
		$Stars.add_child(star)
		
		i += 1

func _process(delta: float) -> void:
	if get_tree().paused:
		return
	
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
		chunk_tick_timer = 1
		
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$UI/Control/PauseMenu.visible = true
		
		$UI/Control/PauseMenu/Panel/Flow/Resume.grab_focus()
		
		get_tree().paused = true
