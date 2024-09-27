extends StaticBody2D

enum BlockColor { GREEN, BLUE, ORANGE, RED }

@export var initial_health: int = 4:
	set(value):
		initial_health = clamp(value, 1, 4)
		set_health_and_color(initial_health)

var current_color: BlockColor
var health: int

signal block_destroyed

func _ready():
	reset()

func hit():
	set_health_and_color(health - 1)
	if health <= 0:
		block_destroyed.emit()
		queue_free()

func set_health_and_color(new_health: int):
	health = clamp(new_health, 0, 4)
	if health > 0:
		current_color = BlockColor.values()[health - 1]
		update_sprite()
	else:
		hide()

func update_sprite():
	for sprite in get_children():
		if sprite is Sprite2D:
			sprite.visible = false
	
	match current_color:
		BlockColor.GREEN:
			$Sprite_Green.visible = true
		BlockColor.BLUE:
			$Sprite_Blue.visible = true
		BlockColor.ORANGE:
			$Sprite_Orange.visible = true
		BlockColor.RED:
			$Sprite_Red.visible = true

func reset():
	set_health_and_color(initial_health)
	show()
