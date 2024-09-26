extends Node

var blocks_remaining = 0
var game_over = false

@onready var ball = $Ball
@onready var paddle = $Paddle
@onready var blocks_container = $Blocks

func _ready():
	ball.connect("ball_out_of_bounds", Callable(self, "_on_ball_out_of_bounds"))
	for block in blocks_container.get_children():
		block.connect("block_destroyed", Callable(self, "_on_block_destroyed"))
	reset_game()

func _process(_delta):
	if game_over and Input.is_action_just_pressed("ui_accept"):
		reset_game()

func reset_game():
	game_over = false
	ball.reset_ball()
	paddle.position.x = get_viewport().size.x / 2
	reset_blocks()

func reset_blocks():
	for block in blocks_container.get_children():
		if block.has_method("reset"):
			block.reset()
	
	blocks_remaining = blocks_container.get_child_count()

func _on_ball_out_of_bounds():
	game_over = true
	print("Game Over! Press Enter to restart.")

func _on_block_destroyed():
	blocks_remaining -= 1
	if blocks_remaining <= 0:
		game_over = true
		print("You Win! Press Enter to restart.")
