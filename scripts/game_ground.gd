extends Node2D

var current_interaction_area = null
signal dialogue_continue
signal choice_made

func _ready() -> void:
	$UI/Control/Dialogue.visible = false

func _process(delta: float) -> void:
	if current_interaction_area:
		$UI/Control/Interact.visible = true
		$UI/Control/Interact/End.text = "TO " + (current_interaction_area.interact_text)
		
		if Input.is_action_just_pressed("interact"):
			if "_interact" in current_interaction_area.get_parent(): current_interaction_area.get_parent()._interact($PlayerGround)
	else:
		$UI/Control/Interact.visible = false

func dialogue(text: String) -> void:
	$UI/Control/Dialogue/InputIcon.visible = false
	$UI/Control/Dialogue.visible = true
	
	var displayed_text = ""
	
	var i = 0
	while i < text.length():
		displayed_text = displayed_text + text[i]
		
		$UI/Control/Dialogue/Label.text = displayed_text
		
		$Dialogue.play()
		
		await get_tree().create_timer(0.03).timeout
		
		i += 1
		
	$UI/Control/Dialogue/InputIcon.visible = true

	await dialogue_continue
	
	$UI/Control/Dialogue.visible = false
	
	return
	
func make_choice(options: Dictionary = {}) -> String:
	$UI/Control/DialogueOptions.visible = true
	
	var dialogue_select_button_scene = preload("res://scenes/dialogue_select_button.tscn")
	
	for n in $UI/Control/DialogueOptions.get_children(): if n.is_class("Button"): n.free()
	
	var first_button = null
	var last_button = null
	
	for n in options.keys():
		var dialogue_select_button = dialogue_select_button_scene.instantiate()
		
		dialogue_select_button.name = n
		dialogue_select_button.text = options[n]
		dialogue_select_button.game = self
		
		$UI/Control/DialogueOptions.add_child(dialogue_select_button)
		
		if !first_button: first_button = dialogue_select_button
		last_button = dialogue_select_button
		
	first_button.focus_neighbor_top = NodePath(last_button.get_path())
	
	last_button.focus_neighbor_bottom = NodePath(first_button.get_path())
		
	first_button.grab_focus()
	
	var response = await choice_made
	
	$UI/Control/DialogueOptions.visible = false
	
	return response
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("dialogue_continue"):

		dialogue_continue.emit()
