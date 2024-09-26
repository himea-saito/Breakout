@tool
extends StaticBody2D

@onready var sprite: Sprite2D = $WallTexture


func _ready() -> void:
	var sprite_size = sprite.texture.get_size()
	var wall_size = scale * sprite_size

	sprite.region_rect = Rect2(Vector2.ZERO, wall_size)
	sprite.scale /= scale
