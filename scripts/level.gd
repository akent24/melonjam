extends Node2D
@export var player_node: CharacterBody2D
func restart():
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/control.tscn")
func _process(float) -> void:
	restart()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if player_node:
		player_node.get_damage(1)
