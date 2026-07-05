extends CharacterBody2D
var speed = 60
var health = 150
func _physics_process(delta: float) -> void: #Крч здесь все функции почти вызываются
	walk(delta)
func walk(delta: float) -> void: #Здесь ходит он крч
	$AnimatedSprite2D.play("walk")
	if velocity.x >= 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	velocity.x = speed
	move_and_slide()
func wait() -> void: #функция ожидания между патрулированиями
	$AnimatedSprite2D.play("idle")
	get_tree().create_timer(3)
func take_damage(amount: int) -> void: # Функция что-бы он по ебалу получал
	pass
