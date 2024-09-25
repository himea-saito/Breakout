extends CharacterBody2D

@export var speed: int = 750

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui-left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui-right"):
		velocity.x += 1

	move_and_collide(velocity * delta * speed)
