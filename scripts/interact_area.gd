extends Area2D

@export var interact_text: String = "INTERACT"
@export var interact_node: Node2D = get_parent()
var game = null

func _on_body_entered(body: Node2D) -> void:
	print("dgsijgs")
	if !game: return
	
	if (body.get_name() == "PlayerGround") or (game.get_node("PlayerGround").is_ancestor_of(body)):
		game.current_interaction_area = self

func _on_body_exited(body: Node2D) -> void:
	if !game: return
	
	if (body.get_name() == "PlayerGround") or (game.get_node("PlayerGround").is_ancestor_of(body)):
		if game.current_interaction_area == self: game.current_interaction_area = null
