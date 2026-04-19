extends Node

# Preload the player frame scene for echo visuals during rewind
const PLAYER_FRAME = preload("res://scenes/player_frame.tscn")

# If true, pause the game tree when rewinding
@export var pause_on_rewind: bool = true
# If true, use simple rewind; otherwise use complex rewind with echo visuals
@export var is_simple_rewind: bool = true
# Step size for rewind navigation (not currently used)
@export var rewind_step: int = 1

# Reference to the player node
var player: Player = null
# Reference to the level node
var level: Level = null

# Maximum number of frames to store for rewind history
const MAX_REWIND_FRAMES = 300
# Array storing recorded player states (position, velocity, animation, etc.)
var player_frames: Array[Dictionary]
# Array of echo sprites shown during complex rewind for visual feedback
var player_echoes: Array[AnimatedSprite2D]

# Whether we are currently in rewind mode
var is_rewinding: bool = false
# Current frame index during complex rewind navigation
var rewind_frame: int = 0

func _ready() -> void:
	# Pre-instantiate all player echo sprites for the rewind buffer
	for i in MAX_REWIND_FRAMES:
		player_echoes.append(PLAYER_FRAME.instantiate() as AnimatedSprite2D)

# Set the player reference after player node is ready
func set_player(_player: Player) -> void:
	player = _player

# Set the level reference and add echo sprites to the level
func set_level(_level: Level) -> void:
	if level:
		# Remove echoes from previous level
		for e in player_echoes:
			level.remove_child(e)
	level = _level
	# Add echo sprites to new level
	for e in player_echoes:
		level.add_child(e)
	
# Main physics process - routes to either simple or complex rewind based on setting
func _physics_process(_delta: float) -> void:
	# Changes pause and rewind modes
	if not get_tree().paused:
		if Input.is_action_just_pressed("rewind_mode"):
			is_simple_rewind = not is_simple_rewind
		elif Input.is_action_just_pressed("pause_mode"):
			pause_on_rewind = not pause_on_rewind
	
	if is_simple_rewind:
		simple_rewind()
	else:
		complex_rewind()
	
# Complex rewind with visual echoes - supports scrubbing through history
func complex_rewind() -> void:
	if player:
		# Toggle rewind mode on rewind key press
		if Input.is_action_just_pressed("rewind"):
			if is_rewinding:
				# Stop rewinding - restore player to current frame
				is_rewinding = false
				rewind_frame = clamp(rewind_frame, 0, player_frames.size() - 1)
				player.process_mode = Node.PROCESS_MODE_INHERIT
				player.camera.process_mode = Node.PROCESS_MODE_INHERIT
				var frame: Dictionary = player_frames[rewind_frame]
				player.global_position = frame["position"]
				player.velocity = frame["velocity"]
				player.animated_sprite.animation = frame["animation"]
				player.animated_sprite.frame = frame["animation_frame"]
				player.animated_sprite.flip_h = frame["flip"]
				# Hide all echo sprites when not rewinding
				for e in player_echoes:
					e.visible = false
				if pause_on_rewind:
					get_tree().paused = false
			else:
				# Start rewinding - disable player physics, show all echoes
				is_rewinding = true
				rewind_frame = player_frames.size() - 1
				player.process_mode = Node.PROCESS_MODE_DISABLED
				player.camera.process_mode = Node.PROCESS_MODE_ALWAYS
				if pause_on_rewind:
					get_tree().paused = true
				# Show all recorded echoes
				for i in player_frames.size():
					player_echoes[i].visible = true
					player_echoes[i].global_position = player_frames[i]["position"]
					player_echoes[i].animation = player_frames[i]["animation"]
					player_echoes[i].frame = player_frames[i]["animation_frame"]
					player_echoes[i].flip_h = player_frames[i]["flip"]
		# Handle scrub navigation while rewinding
		if is_rewinding:
			# Set's the current rewind frame based on rewind step (to move faster or slower)
			if Input.is_action_pressed("move_left"):
				rewind_frame = clamp(rewind_frame - rewind_step, 0, player_frames.size() - 1)
			if Input.is_action_pressed("move_right"):
				rewind_frame = clamp(rewind_frame + rewind_step, 0, player_frames.size() - 1)
			# Restore player state to current rewind frame
			var frame: Dictionary = player_frames[rewind_frame]
			player.global_position = frame["position"]
			player.velocity = frame["velocity"]
			player.animated_sprite.animation = frame["animation"]
			player.animated_sprite.frame = frame["animation_frame"]
			player.animated_sprite.flip_h = frame["flip"]
			# Sets the process mode for player and camera
			player.process_mode = Node.PROCESS_MODE_DISABLED
			player.camera.process_mode = Node.PROCESS_MODE_ALWAYS
		else:
			# Record current frame state for rewind history
			var frame: Dictionary = {
				"position": player.global_position,
				"velocity": player.velocity,
				"animation": player.animated_sprite.animation,
				"animation_frame": player.animated_sprite.frame,
				"flip": player.animated_sprite.flip_h
			}
			player_frames.append(frame)
			# Remove oldest frames when buffer is full
			if player_frames.size() > MAX_REWIND_FRAMES:
				player_frames.pop_front()
			# Sets the process mode for player
			player.process_mode = Node.PROCESS_MODE_INHERIT

# Simple rewind - plays backward through history while rewind key is held
func simple_rewind() -> void:
	if player:
		if Input.is_action_pressed("rewind"):
			if player_frames.size() > 0:
				# Disable player physics while rewinding
				player.process_mode = Node.PROCESS_MODE_DISABLED
				player.camera.process_mode = Node.PROCESS_MODE_ALWAYS
				if pause_on_rewind:
					get_tree().paused = true
				# Pop last frame and restore player state
				var frame: Dictionary = player_frames.pop_back()
				player.global_position = frame["position"]
				player.velocity = frame["velocity"]
				player.animated_sprite.animation = frame["animation"]
				player.animated_sprite.frame = frame["animation_frame"]
				player.animated_sprite.flip_h = frame["flip"]
		else:
			# Record current frame state
			var frame: Dictionary = {
				"position": player.global_position,
				"velocity": player.velocity,
				"animation": player.animated_sprite.animation,
				"animation_frame": player.animated_sprite.frame,
				"flip": player.animated_sprite.flip_h
			}
			player_frames.append(frame)
			# Remove oldest frames when buffer is full
			if player_frames.size() > MAX_REWIND_FRAMES:
				player_frames.pop_front()
			# Resume normal gameplay
			if pause_on_rewind:
				get_tree().paused = false
			player.process_mode = Node.PROCESS_MODE_INHERIT
	pass

	
