extends Control

func _ready():
    $VBoxContainer/StartGame.connect("pressed", Callable(self, "_on_start_game_pressed"))
    $VBoxContainer/Exit.connect("pressed", Callable(self, "_on_exit_pressed"))

    $MenuMusic.play()


func _on_start_game_pressed():
    # Replace "res://scenes/game.tscn" with the path to your main game scene
    get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_exit_pressed():
    get_tree().quit()