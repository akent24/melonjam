extends CharacterBody2D
@onready var UI = $"../UI"
const SPEED = 70.0
const JUMP_VELOCITY = -200.0
var player_stats = { "player_hp": 7, "attak_damage": 40, 
}
var dash_fill_amount := 0.0
var dash_cooldown := 0.0
var is_attacking := false
func _physics_process(delta: float) -> void:
	if dash_cooldown > 0.0:
		dash_cooldown -= delta
		if dash_cooldown <= 0.0:
			dash_cooldown = 0.0
	if not is_on_floor():
		velocity += get_gravity() * 0.5 * delta
		if is_attacking == false:
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
		if Input.is_action_just_pressed("dash") and dash_cooldown == 0.0:
			dash_cooldown = 3.0
			UI.get_node("Dash").frame = 1
		
	move_and_slide()
	attak()

func attak() -> void:
	if Input.is_action_just_pressed("attak"):
		is_attacking = true
		$AnimatedSprite2D.play("attak")
		$Area2D/AnimatedSprite2D.visible = true
		$Area2D/AnimatedSprite2D.play("attak")
		$Area2D/CollisionShape2D.disabled = false
		
func get_damage() -> void:
	player_stats["player_hp"] -= 1
	

func _on_animated_sprite_2d_animation_finished() -> void:
	$Area2D/AnimatedSprite2D.visible = false
	is_attacking = false
