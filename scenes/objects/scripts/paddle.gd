extends CharacterBody2D

@export var speed: int = 750
var last_position: Vector2
var current_velocity: Vector2 = Vector2.ZERO


@onready var ball = $"../Ball"

func _ready():
	last_position = position
	ball.ball_launched.connect(on_ball_launched)

func _physics_process(delta: float) -> void:
	if ball.is_launched:
		var input_vector = Vector2.ZERO

		if Input.is_action_pressed("ui-left"):
			input_vector.x -= 1
		if Input.is_action_pressed("ui-right"):
			input_vector.x += 1

		velocity = input_vector * speed
		move_and_slide()

		# Calculate the current velocity for the ball to bounce off
		current_velocity = (position - last_position) / delta
		last_position = position
	else:
		# Lock paddle in place until ball is launched
		velocity = Vector2.ZERO
		current_velocity = Vector2.ZERO

func on_ball_launched():
	ball.is_launched = true
