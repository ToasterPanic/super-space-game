extends "res://scripts/character_ground.gd"

var last_aim_direction = Vector2(0, 0)
var alerted = false

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

## The enemy's starting gun. Leave blank for no weapon
@export var starting_gun: String = &"pistol"
## The enemy's starting health.
@export var starting_health: int = 50
## Is the enemy's AI enabled?
@export var concious: bool = true
## Will the enemy always chase the player?
@export var always_sees_player: bool = false
## The time it takes for an enemy to start shooting / notice the player.
@export var reaction_time: float = 0.35
## A path for the enemy to follow while idle.
@export var points: Array[Node2D] = []
## Time to wait between points while idle.
@export var wait_time_between_points: int = 5

var current_node = null

var active_alertness_marker = null
var alertness_marker_scene = preload("res://scenes/alertness_marker.tscn")

var current_point = 0

@export var inaccuracy: int = 15

func _ready() -> void:
	super()
	
	health = starting_health
	
	set_ground_gun(starting_gun)

func _process(delta: float) -> void:
	super(delta)
	
	if dead: 
		$Detecting.stop()
		return
		
	if !concious: 
		$Detecting.stop()
		return
	
	if !player: 
		if game:
			player = game.get_node("PlayerGround")
		else: return
		
	if always_sees_player:
		ai_mode = AI_MODE_ATTACK
		last_seen_player_position = player.global_position
		
	if reaction_timer > 0:
		if !active_alertness_marker:
			active_alertness_marker = alertness_marker_scene.instantiate()
			
			active_alertness_marker.enemy = self 
			
			player.add_child(active_alertness_marker)
	else:
		if active_alertness_marker:
			active_alertness_marker.queue_free()
			active_alertness_marker = null
	
	if ai_mode == AI_MODE_IDLE:
		$LineOfSight.look_at(player.global_position)
		
		if $LineOfSight.get_collider() && player.is_ancestor_of($LineOfSight.get_collider()):
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
			
		if points.size() > 0:
			if !current_node: current_node = points[0]
			
			if $Navagent.is_navigation_finished():
				if points.find(current_node) + 1 > points.size() - 1:
					current_node = points[0]
				else:
					current_node = points[points.find(current_node) + 1]
			else:
				var next_position = $Navagent.get_next_path_position()
				next_position.y -= 32
				var axes = global_position.direction_to(next_position)
				
				horizontial_movement = axes.x
				vertical_movement = axes.y
				
			if !$Navagent.target_position or ($Navagent.target_position != current_node.position): $Navagent.target_position = current_node.position
		
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
			firing = false 
			
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
