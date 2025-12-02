extends Node2D

var chunk_tick_timer = 0
var chunks = {}
var chunk_process_distance = 6

var asteroid_scene = preload("res://scenes/asteroid.tscn")

func world_to_chunk(position: Vector2) -> Vector2:
	return Vector2(floori(position.x / 1024), floori(position.y / 1024))
	
func chunk_to_world(position: Vector2) -> Vector2:
	return Vector2(floori(position.x * 1024), floori(position.y * 1024))

func _process(delta: float) -> void:
	$UI/Control/BoostText.text = "BOOST: " + str($Player.boost)
	$UI/Control/Distance.text = "DIST: " + str(floori($Player.position.length()))
	
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
