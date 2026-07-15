extends CharacterBody2D
var speed := 50
var health := 100
var is_waiting := false
var direction := -1
var zombie_stats := {"Zombie_hp": 150, "Zombie_attack": 1
}
var is_attacking := false
var is_dead := false
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void: #Крч здесь все функции почти вызываются
	if is_dead == false:
		if is_waiting == false:
			walk(delta)
		not_fall()
	else:
		return
func walk(delta: float) -> void: #Здесь ходит он крч
	if is_waiting == true:
		return
	if is_dead == true:
		return
	else:
		$AnimatedSprite2D.play("walk")
		velocity.x = direction * speed
		move_and_slide()
func wait() -> void: #функция ожидания между патрулированиями
	velocity.x = 0.0
	$AnimatedSprite2D.play("idle")
	is_waiting = true
	await get_tree().create_timer(3).timeout
	is_waiting = false
func take_damage(amount: int) -> void: # Функция что-бы он по ебалу получал
	zombie_stats["Zombie_hp"] -= amount
	death()
func not_fall():
	var VColliding = $RayCast2D.is_colliding()
	if VColliding == false and is_waiting == false:
		await wait()
		is_waiting = false
		direction *= -1
		if direction == -1:
			$AnimatedSprite2D.flip_h = false
			$Area2D/AnimatedSprite2D.flip_h = false
			$Area2D/CollisionShape2D.position.x = -8
			$RayCast2D.position.x = -15
		else:
			$AnimatedSprite2D.flip_h = true
			$Area2D/AnimatedSprite2D.flip_h = true
			$Area2D/CollisionShape2D.position.x = 10
			$RayCast2D.position.x = 15
		$RayCast2D.force_raycast_update()
	else:
		pass
func death():
	if zombie_stats["Zombie_hp"] <= 0:
		is_dead = true
		is_waiting = false
		is_attacking = false
		$AnimatedSprite2D.play("death")
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
	else:
		return
