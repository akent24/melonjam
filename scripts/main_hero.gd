extends CharacterBody2D
@onready var UI = $"../UI"
const SPEED := 70.0
const JUMP_VELOCITY := -200.0
const DASH_SPEED := 200.0
var player_stats := { "player_hp": 7, "attak_damage": 40
}
var inventory := []
var dash_fill_amount := 0.0
var dash_cooldown := 0.0
var is_attacking := false
var dash_timer := 0.0
func _physics_process(delta: float) -> void:
	if dash_timer > 0.0:
		dash_timer -= delta
		if $AnimatedSprite2D.flip_h == false:
			velocity.x = -DASH_SPEED
		else:
			velocity.x = DASH_SPEED
		velocity.y = 0
		move_and_slide()
		return
	if dash_cooldown > 0.0:
		dash_cooldown -= delta
		var current_frame = int((2.0 - dash_cooldown) / 2.0 * 10)
		UI.get_node("Dash").frame = current_frame
		if dash_cooldown <= 0.0:
			dash_cooldown = 0.0
	if not is_on_floor():
		velocity += get_gravity() * 0.5 * delta
		if is_attacking == false and dash_timer <= 0:
			$AnimatedSprite2D.play("jamp")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and is_attacking == false:
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("move_left", "move_right")
	if direction and is_attacking == false:
		velocity.x = direction * SPEED
		if direction < 0:
			$AnimatedSprite2D.flip_h = false
			$Area2D.scale.x = 1
			$Area2D.position.x = -8.4
		else:
			$AnimatedSprite2D.flip_h = true
			$Area2D.scale.x = -1
			$Area2D.position.x = 8.4
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor() and is_attacking == false:
		if velocity.length() == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("walk")
	if Input.is_action_just_pressed("dash") and dash_cooldown == 0.0 and is_attacking == false:
		$AnimatedSprite2D.play("dash")
		dash_cooldown = 1.8
		dash_timer = 0.2
	move_and_slide()
	attak()
func attak() -> void:
	if Input.is_action_just_pressed("attak"):
		is_attacking = true
		$AnimatedSprite2D.play("attak")
		$Area2D/AnimatedSprite2D.visible = true
		$Area2D/AnimatedSprite2D.play("attak")
		$Area2D/CollisionShape2D.disabled = false
func get_damage(amount: int) -> void:
	player_stats["player_hp"] -= amount
	update_hearts()
func death() -> void:
	if player_stats["player_hp"] <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attak":
		$Area2D/CollisionShape2D.disabled = true
		$Area2D/AnimatedSprite2D.visible = false
		is_attacking = false
func update_hearts() -> void:
	for i in range(1, 8):
		var heart = UI.get_node("Heart" + str(i))
		if i <= player_stats["player_hp"]:
			heart.frame = 0
		else:
			heart.frame = 1
			await get_tree().create_timer(0.02).timeout
			heart.frame = 2
	death()
func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
