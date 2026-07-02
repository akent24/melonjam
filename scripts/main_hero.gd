extends CharacterBody2D


const SPEED = 70.0
const JUMP_VELOCITY = -200.0
var player_stats = { "player_hp": 7, 
}

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 0.5 * delta
		$AnimatedSprite2D.play("jamp")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor():
		if velocity.length() == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("walk")
	move_and_slide()

func attak() -> void:
	if Input.is_action_just_pressed("attak"):
		$Area2D/AnimatedSprite2D.visible = true
		$Area2D/AnimatedSprite2D.play("attak")
		$Area2D/CollisionShape2D.disabled = false
		
func get_damage() -> void:
	pass
