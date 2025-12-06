extends Node2D

var transitioning = false

func _ready() -> void:
	$UI/Control/Title.visible = false
	$UI/Control/ControllerInfo.visible = true
	$UI/Control/ControllerInfo/Box/Flow/Continue.grab_focus()
	


func _on_continue_pressed() -> void:
	if transitioning: return 
	
	transitioning = true 
	
	$UI/Control/ControllerInfo/Box/Flow/Continue.release_focus()
	var i = 0
	
	while i < 6:
		$UI/Control/ControllerInfo.modulate.a -= 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Title.visible = true
	$UI/Control/ControllerInfo.visible = false
	
	$UI/Control/Title.modulate.a = 0
		
	i = 0
	
	while i < 6:
		$UI/Control/Title.modulate.a += 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Title/Buttons/NewGame.grab_focus()
	
	transitioning = false


func _on_quit_pressed() -> void:
	if transitioning: return 
	
	transitioning = true 
	
	get_viewport().gui_release_focus()
	var i = 0
	
	while i < 6:
		$UI/FadeToBlack.modulate.a += 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	get_tree().quit()


func _on_credits_pressed() -> void:
	if transitioning: return 
	
	transitioning = true 
	
	get_viewport().gui_release_focus()
	var i = 0
	
	while i < 6:
		$UI/Control/Title.modulate.a -= 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Title.visible = false
	$UI/Control/Credits.visible = true
	
	$UI/Control/Credits.modulate.a = 0
	
	i = 0
	
	while i < 6:
		$UI/Control/Credits.modulate.a += 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Credits/Buttons/ExitCredits.grab_focus()

	transitioning = false

func _on_exit_credits_pressed() -> void:
	if transitioning: return 
	
	transitioning = true 
	
	get_viewport().gui_release_focus()
	var i = 0
	
	while i < 6:
		$UI/Control/Credits.modulate.a -= 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Credits.visible = false
	$UI/Control/Title.visible = true
	
	$UI/Control/Title.modulate.a = 0
	
	i = 0
	
	while i < 6:
		$UI/Control/Title.modulate.a += 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Title/Buttons/NewGame.grab_focus()
		
	transitioning = false


func _on_settings_pressed() -> void:
	if transitioning: return 
	
	transitioning = true 
	
	get_viewport().gui_release_focus()
	var i = 0
	
	while i < 6:
		$UI/Control/Title.modulate.a -= 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Title.visible = false
	$UI/Control/Settings.visible = true
	
	$UI/Control/Settings.modulate.a = 0
	
	i = 0
	
	while i < 6:
		$UI/Control/Settings.modulate.a += 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Settings/Scroll/Flow/Back.grab_focus()

	transitioning = false

func _on_settings_back_pressed() -> void:
	if transitioning: return 
	
	transitioning = true 
	
	get_viewport().gui_release_focus()
	var i = 0
	
	while i < 6:
		$UI/Control/Settings.modulate.a -= 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Settings.visible = false
	$UI/Control/Title.visible = true
	
	$UI/Control/Title.modulate.a = 0
	
	i = 0
	
	while i < 6:
		$UI/Control/Title.modulate.a += 0.2
		
		await get_tree().create_timer(0.2).timeout
		
		i += 1
		
	$UI/Control/Title/Buttons/NewGame.grab_focus()
		
	transitioning = false
	
