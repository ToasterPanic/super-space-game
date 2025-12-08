extends Sprite2D

@onready var game = get_owner()
@export var active_mission_requirement: String = ""

func _on_enter_hitbox_body_entered(body: Node2D) -> void:
	if active_mission_requirement != "":
		if global.stats.active_mission != active_mission_requirement: return
		
	if body.get_name() == "Player":
		game.enter_physical(get_name())
