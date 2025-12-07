extends Panel

@onready var game = get_parent().get_parent().get_parent()

func _resume() -> void:
	$UiBack.play()
	
	while Input.is_action_pressed("pause"):
		await get_tree().create_timer(0).timeout
		
	visible = false
	get_tree().paused = false


func _on_resume_pressed() -> void:
	_resume()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): 
		if $Settings.visible:
			# This is probably no good!
			$Settings._on_back_pressed()
			
			$Settings.visible = false
			$Panel/Flow/Resume.grab_focus()
		elif visible:
			_resume()


func _on_settings_pressed() -> void:
	if visible:
		$UiSelect.play()
		$Settings.visible = true
		$Settings/Scroll/Flow/Back.grab_focus()

func _on_settings_back_pressed() -> void:
	if visible:
		$UiBack.play()
		$Settings.visible = false
		$Panel/Flow/Resume.grab_focus()
