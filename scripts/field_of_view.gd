extends TileMapLayer

@onready var game = get_parent()
@onready var player = game.get_node("PlayerGround")

var last_position = null
var time_until_next_check = 0

var radius = 24

func _tile_to_world(pos: Vector2) -> Vector2:
	return Vector2(pos.x * 64, pos.y * 64)
	
func _world_to_tile(pos: Vector2) -> Vector2:
	return Vector2(roundi(pos.x) / 64, roundi(pos.y) / 64)

func _process(delta: float) -> void:
	position = _tile_to_world(_world_to_tile(player.global_position))
	
	time_until_next_check -= delta
	
	if (time_until_next_check <= 0) && (last_position != position):
		last_position = position
		
		time_until_next_check = 0
		
		var x_offset = radius / -2
		
		while x_offset <= radius / 2:
			var y_offset = radius / -2
			
			while y_offset <= radius / 2:
				var tile_pos = Vector2(x_offset, y_offset)
				var world_pos = _tile_to_world(tile_pos)
				
				$Cast.position = ( world_pos / 2) + Vector2(16, 16)
				$Cast.target_position.x = ((global_position + world_pos) - player.global_position).length()
				$Cast.look_at(player.global_position)
				$Cast.force_raycast_update()
				
				if (!$Cast.get_collider()) || ($Cast.get_collider() == player.get_node("Hitbox")):
					set_cell(tile_pos, -1, Vector2i(0, 0))
				else:
					set_cell(tile_pos, 0, Vector2i(0, 0))
				
				y_offset += 1
				
			x_offset += 1
