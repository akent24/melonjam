extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")



func _on_h_slider_value_changed(value: float) -> void:
	MusicManager.set_volume(value)
