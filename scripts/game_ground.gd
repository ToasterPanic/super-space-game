extends Node2D

var current_interaction_area = null
signal dialogue_continue
signal choice_made

var dialogue_colors = {
	"generic": Color("fff"),
	"player": Color("fff"),
	"player_woozy": Color("fff"),
	"doctor_1": Color("00ffffff"),
	"doctor_2": Color("00a2ffff"),
}

var dialogue_speed = {
	"generic": 0.037,
	"player_slow": 0.06,
	"player_woozy": 0.2,
}

func save_game() -> void:
	$UI/Control/SaveIndicator.visible = true
	
	global.stats.position = {
		"x": $PlayerGround.global_position.x,
		"y": $PlayerGround.global_position.y
	}
	
	global.save_game()
	
	await get_tree().create_timer(2).timeout
	
	$UI/Control/SaveIndicator.visible = false
	
func checkpoint() -> void:
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
		
	global.checkpoint = packed_scene

func _ready() -> void:
	$UI/Control/Dialogue.visible = false
	
	var location_scene = load("res://scenes/locations/space_station_1.tscn").instantiate()
	
	for n in location_scene.get_children():
		location_scene.remove_child(n)
		add_child(n)
		
		if "game" in n:
			n.game = self
		
		# This gets all descendants. Copied it off the forums don't ask me how it works
		for o in n.find_children("*", "", true, false):
			if "game" in o:
				o.game = self
				
	for n in get_children():
		if "_ground_ready" in n:
			n._ground_ready()
		
	location_scene.free()
	
	if global.stats.position:
		print("AAA ", global.stats.position)
		$PlayerGround.global_position.x = global.stats.position.x
		$PlayerGround.global_position.y = global.stats.position.y
		
		global.stats.position = null
		
	if global.stats.loaded:
		save_game()
	else:
		global.stats.loaded = true

func _process(delta: float) -> void:
	if current_interaction_area:
		$UI/Control/Interact.visible = true
		$UI/Control/Interact/End.text = "TO " + (current_interaction_area.interact_text)
		
		if Input.is_action_just_pressed("interact"):
			if "_interact" in current_interaction_area.get_parent(): current_interaction_area.get_parent()._interact($PlayerGround)
	else:
		$UI/Control/Interact.visible = false

func dialogue(text: String, type: String = "generic", allow_input: bool = true) -> void:
	$UI/Control/Dialogue/InputIcon.visible = false
	$UI/Control/Dialogue.visible = true
	
	var speed = dialogue_speed.generic
	
	if dialogue_speed.has(type): speed = dialogue_speed[type]
	
	$UI/Control/Dialogue/Label.label_settings.font_color = dialogue_colors.generic
	
	if dialogue_colors.has(type): $UI/Control/Dialogue/Label.label_settings.font_color = dialogue_colors[type]
	
	var displayed_text = ""
	
	var i = 0
	while i < text.length():
		displayed_text = displayed_text + text[i]
		
		$UI/Control/Dialogue/Label.text = displayed_text
		
		$Dialogue.play()
		
		await get_tree().create_timer(speed).timeout
		
		i += 1
		
	if allow_input:
		$UI/Control/Dialogue/InputIcon.visible = true

		await dialogue_continue
		
		$UI/Control/Dialogue.visible = false

func end_dialogue() -> void:
	$UI/Control/Dialogue.visible = false
	
	return
	
func make_choice(options: Dictionary = {}) -> String:
	$UI/Control/DialogueOptions.visible = true
	
	var dialogue_select_button_scene = preload("res://scenes/dialogue_select_button.tscn")
	
	for n in $UI/Control/DialogueOptions.get_children(): if n.is_class("Button"): n.queue_free()
	
	var first_button = null
	var last_button = null
	
	for n in options.keys():
		var dialogue_select_button = dialogue_select_button_scene.instantiate()
		
		dialogue_select_button.name = n
		dialogue_select_button.id = n
		dialogue_select_button.text = options[n]
		dialogue_select_button.game = self
		
		$UI/Control/DialogueOptions.add_child(dialogue_select_button)
		
		if !first_button: first_button = dialogue_select_button
		last_button = dialogue_select_button
		
	first_button.focus_neighbor_top = NodePath(last_button.get_path())
	
	last_button.focus_neighbor_bottom = NodePath(first_button.get_path())
		
	first_button.grab_focus()
	
	var button = await choice_made
	
	var response = button.id
	
	$UI/Control/DialogueOptions.visible = false
	
	return response
	
func get_vignette_parameter(name: String) -> float:
	return $UI/Vignette.material.get_shader_parameter(name)
	
func set_vignette_parameter(name: String, value: float) -> void:
	$UI/Vignette.material.set_shader_parameter(name, value)
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("dialogue_continue"):
		dialogue_continue.emit()
	if event.is_action_pressed("pause"):
		$UI/Control/PauseMenu.visible = true
		
		$UI/Control/PauseMenu/Panel/Flow/Resume.grab_focus()
		
		get_tree().paused = true
