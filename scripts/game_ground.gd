extends Node2D

func _process(delta: float) -> void:
	if $ExitShip/InteractBox.get_overlapping_bodies().has($PlayerGround):
		$UI/Control/LeaveInteract.visible = true
		
		if global.using_gamepad: $UI/Control/LeaveInteract/InputIcon.event_index = 1
		else: $UI/Control/LeaveInteract/InputIcon.event_index = 0
		
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		$UI/Control/LeaveInteract.visible = false
