extends Node2D

var current_interaction_area = null

func _ready() -> void:
	print(Input.get_joy_name(0))

func _process(delta: float) -> void:
	if current_interaction_area:
		$UI/Control/Interact.visible = true
		$UI/Control/Interact/End.text = "TO " + (current_interaction_area.interact_text)
		
		if Input.is_action_just_pressed("interact"):
			if "_interact" in current_interaction_area.get_parent(): current_interaction_area.get_parent()._interact()
	else:
		$UI/Control/Interact.visible = false
