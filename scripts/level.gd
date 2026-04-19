class_name Level extends Node2D

func _ready() -> void:
	# Register this level with the game manager to enable rewind echoes
	GameManager.set_level(self)
