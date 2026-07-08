extends CharacterBody2D
var speed = 50 
var health = 150
var is_waiting := false
var direction = -1
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void: #Крч здесь все функции почти вызываются
	walk(delta)
	not_fall()
func walk(delta: float) -> void: #Здесь ходит он крч
	if is_waiting == true:
		return
	$AnimatedSprite2D.play("walk")
	velocity.x = direction * speed
	move_and_slide()
func wait() -> void: #функция ожидания между патрулированиями
	$AnimatedSprite2D.play("idle")
	is_waiting = true
	await get_tree().create_timer(3).timeout
	is_waiting = false
func take_damage(amount: int) -> void: # Функция что-бы он по ебалу получал
	pass
func not_fall():
	var VColliding = $RayCast2D.is_colliding()
	if VColliding == false and is_waiting == false:
		await wait()
		direction *= -1
		scale.x = -scale.x
	else:
		pass
