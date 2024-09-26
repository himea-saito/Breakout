extends CharacterBody2D

var speed: float = 800.0
var direction: Vector2 = Vector2.UP
var paddle
var is_launched = false
var launch_angle: float = 0.0

#Deflection and influence variables
const MAX_DEFLECTION_ANGLE: float = PI / 3  #60 degrees
const PADDLE_INFLUENCE: float = 0.05        #Reduced to a much smaller value
const MAX_PADDLE_EFFECT: float = 0.3       	#Maximum effect the paddle can have on direction
const MAX_LAUNCH_ANGLE: float = PI / 4      #Maximum launch angle (45 degrees)
const LAUNCH_ANGLE_SPEED: float = 2.0       #Speed of angle change

@onready var arrow = $ArrowShape
signal ball_out_of_bounds
signal ball_launched

func _ready():
	paddle = get_node("../Paddle")
	reset_ball()

func _physics_process(delta):
	if not is_launched:
		position = paddle.position + Vector2(0, -40)  #Stay above paddle

		#Rotate launch angle
		if Input.is_action_pressed("ui-left"):
			launch_angle -= LAUNCH_ANGLE_SPEED * delta
		if Input.is_action_pressed("ui-right"):
			launch_angle += LAUNCH_ANGLE_SPEED * delta
		launch_angle = clamp(launch_angle, -MAX_LAUNCH_ANGLE, MAX_LAUNCH_ANGLE)

		#Update arrow rotation
		arrow.rotation = launch_angle

	else:
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider == paddle:
				bounce_off_paddle(collision)
			else:
				direction = direction.bounce(collision.get_normal())
				if collider.has_method("hit"):
					collider.hit()
			velocity = direction * speed

func _process(_delta):
	if not is_launched and Input.is_action_just_pressed("ui-start"):
		launch_ball()

func reset_ball():
	is_launched = false
	position = paddle.position + Vector2(0, -30)
	direction = Vector2.ZERO
	launch_angle = 0
	arrow.rotation = launch_angle
	arrow.visible = true

#Launch the ball with the current launch angle
func launch_ball():
	is_launched = true
	direction = Vector2.UP.rotated(launch_angle)
	velocity = direction * speed
	arrow.visible = false
	ball_launched.emit()
	print(direction)
	print(launch_angle)

func _on_VisibilityNotifier2D_screen_exited():
	ball_out_of_bounds.emit()

func _on_all_blocks_destroyed():
	get_tree().call_group("game", "game_won")

func bounce_off_paddle(collision):
	var paddle_width = paddle.get_node("CollisionShape2D").shape.extents.x * 2
	var hit_pos = collision.get_position()
	var paddle_center = paddle.global_position
	
	#Calculate the hit position relative to the paddle's center
	var relative_hit_x = (hit_pos.x - paddle_center.x) / (paddle_width / 2)
	
	#Calculate the deflection angle based on the hit position
	var deflection_angle = relative_hit_x * MAX_DEFLECTION_ANGLE
	direction = Vector2.UP.rotated(deflection_angle)
	
	#Calculate paddle influence
	var paddle_effect = paddle.current_velocity.x * PADDLE_INFLUENCE
	paddle_effect = clamp(paddle_effect, -MAX_PADDLE_EFFECT, MAX_PADDLE_EFFECT)
	direction.x += paddle_effect
	direction = direction.normalized()
	
	#Ensure the ball always moves upward after hitting the paddle
	if direction.y > 0:
		direction.y *= -1
