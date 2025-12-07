extends "res://scripts/character_ground.gd"

var last_aim_direction = Vector2(0, 0)
var alerted = false

var inaccuracy = 15

var reaction_time = 0.35
var reaction_halve_distance = 720
var reaction_timer = 0

enum {
	AI_MODE_IDLE,
	AI_MODE_ATTACK,
	AI_MODE_SEARCH
}

enum {
	AI_STATE_DEFAULT,
	AI_STATE_CHASE,
	AI_STATE_CHASE_LAST_SEEN
}

var ai_mode = AI_MODE_IDLE
var ai_state = AI_STATE_DEFAULT

var last_seen_player_position = null

@onready var player = null 
var game = null

@export var starting_gun: String = &"pistol"

@export var starting_health: int = 50

func _ready() -> void:
	super()
	
	health = starting_health
	
	set_ground_gun(starting_gun)

func _process(delta: float) -> void:
	super(delta)
	
	if dead: 
		$Detecting.stop()
		return
	
	if !player: 
		if game:
			player = game.get_node("PlayerGround")
		else: return
	
	if ai_mode == AI_MODE_IDLE:
		$LineOfSight.look_at(player.global_position)
		
		if player.is_ancestor_of($LineOfSight.get_collider()):
			var divider = clamp((player.global_position - global_position).length() / reaction_halve_distance, 1, 8) * 1.5
			reaction_timer += delta / divider
			
			$Detecting.playing = true
			$Detecting.pitch_scale = (reaction_timer / reaction_time) * 12
			
			if reaction_time < reaction_timer:
				ai_mode = AI_MODE_ATTACK
				reaction_timer = 0
				$Alerted.play()
		else:
			reaction_timer -= delta
			
			$Detecting.playing = false
			
		if reaction_timer < 0:
			reaction_timer = 0
			
		
	elif ai_mode == AI_MODE_ATTACK:
		$Detecting.playing = false
		
		$LineOfSight.look_at(player.global_position)
		if player.is_ancestor_of($LineOfSight.get_collider()):
			if !$Navagent.target_position or ($Navagent.target_position != player.global_position):
				$Navagent.target_position = player.global_position
				
			ai_state = AI_STATE_CHASE
		elif last_seen_player_position:
			if !$Navagent.target_position or ($Navagent.target_position != last_seen_player_position):
				$Navagent.target_position = last_seen_player_position
				
			ai_state = AI_STATE_CHASE_LAST_SEEN
			
		$HeldItem.look_at(player.global_position)
		
		if ai_state == AI_STATE_CHASE:
			if (player.global_position - global_position).length() > 256:
				if $Navagent.is_navigation_finished():
					last_seen_player_position = null
					ai_mode = AI_MODE_IDLE
				else:
					var next_position = $Navagent.get_next_path_position()
					next_position.y -= 32
					var axes = global_position.direction_to(next_position)
					
					horizontial_movement = axes.x
					vertical_movement = axes.y
					
			else:
				horizontial_movement = 0
				vertical_movement = 0
			
			reaction_timer += delta
			
			if reaction_timer > reaction_time:
				firing = true
				$HeldItem/Cast.rotation_degrees = randi_range(-inaccuracy, inaccuracy)
				
				reaction_timer = reaction_time
				
			last_seen_player_position = player.global_position
		elif ai_state == AI_STATE_CHASE_LAST_SEEN:
			if $Navagent.is_navigation_finished():
				last_seen_player_position = null
				ai_mode = AI_MODE_IDLE
			else:
				var next_position = $Navagent.get_next_path_position()
				next_position.y -= 32
				var axes = global_position.direction_to(next_position)
				
				horizontial_movement = axes.x
				vertical_movement = axes.y
		else:
			reaction_timer -= delta
			
			if reaction_timer < 0:
				firing = false
				reaction_timer = 0
