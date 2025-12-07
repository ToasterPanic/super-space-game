extends PanelContainer

func _ready() -> void:
	$Scroll/Flow/Flow2/MasterVolume.value = global.settings.master_volume
	$Scroll/Flow/Flow3/MusicVolume.value = global.settings.music_volume
	$Scroll/Flow/Flow4/SFXVolume.value = global.settings.sfx_volume

func _on_master_volume_value_changed(value: float) -> void:
	global.settings.master_volume = value
	$Scroll/Flow/Flow2/MasterVolume/Label.text = str(floori(value * 100)) + "%"
	AudioServer.set_bus_volume_linear(0, value)
	$UiSelect.play()

func _on_music_volume_value_changed(value: float) -> void:
	global.settings.music_volume = value
	$Scroll/Flow/Flow3/MusicVolume/Label.text = str(floori(value * 100)) + "%"
	AudioServer.set_bus_volume_linear(1, value)
	$UiSelect.play()

func _on_sfx_volume_value_changed(value: float) -> void:
	global.settings.sfx_volume = value
	$Scroll/Flow/Flow4/SFXVolume/Label.text = str(floori(value * 100)) + "%"
	AudioServer.set_bus_volume_linear(2, value)
	$UiSelect.play()

func _on_back_pressed() -> void:
	global.save_settings()
	get_owner()._on_settings_back_pressed()
