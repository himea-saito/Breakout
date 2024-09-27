extends Node

var blocks_remaining = 0

@onready var game_over_screen: Sprite2D = $GameOver/Lose
@onready var game_over_win_screen: Sprite2D = $GameOver/Win
@onready var game_over_menu_button: Button = $GameOver/MainMenu

@onready var ball = $"Ball"
@onready var paddle = $"Paddle"
@onready var blocks_container = $"Blocks"

func _ready():
	game_over_screen.visible = false
	game_over_win_screen.visible = false
	game_over_menu_button.visible = false
	ball.ball_out_of_bounds.connect(Callable(self, "_on_ball_out_of_bounds"))
	game_over_menu_button.pressed.connect(Callable(self, "_on_menu_button_pressed"))
	set_game()
	$Background.play()

func set_game():
	ball.reset_ball()
	paddle.position.x = get_viewport().size.x / 2
	set_blocks()

func set_blocks():
	blocks_remaining = 0
	_process_blocks_recursive(blocks_container)

func _process_blocks_recursive(node):
	for child in node.get_children():
		if child.has_method("reset"):
			child.reset()
			if not child.is_connected("block_destroyed", Callable(self, "_on_block_destroyed")):
				child.connect("block_destroyed", Callable(self, "_on_block_destroyed"))
			blocks_remaining += 1
		else:
			_process_blocks_recursive(child)

func _on_ball_out_of_bounds():
	game_over_screen.visible = true
	game_over_menu_button.visible = true

	game_over_screen.modulate.a = 0
	game_over_menu_button.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(game_over_screen, "modulate:a", 1, 2)
	tween.tween_property(game_over_menu_button, "modulate:a", 1, 2)

	#Lock paddle in place
	paddle.position.x = get_viewport().size.x / 2

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _on_block_destroyed():
	blocks_remaining -= 1
	if blocks_remaining <= 0:
		call_deferred("_on_all_blocks_destroyed")

func _on_all_blocks_destroyed():
	game_over_win_screen.visible = true
	game_over_menu_button.visible = true

	game_over_win_screen.modulate.a = 0
	game_over_menu_button.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(game_over_win_screen, "modulate:a", 1, 2)
	tween.tween_property(game_over_menu_button, "modulate:a", 1, 2)
