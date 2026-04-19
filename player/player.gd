class_name Player extends CharacterBody2D

# Horizontal movement speed in pixels per second
const SPEED = 200.0
# Initial jump velocity (negative = upward in Godot)
const JUMP_VELOCITY = -300.0

# Reference to the animated sprite for animations
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Reference to the 2D camera for viewport
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	# Register this player with the game manager
	GameManager.set_player(self)

# Physics process called every frame
func _physics_process(delta: float) -> void:
	# Apply gravity when not on the ground
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump input when on the ground
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get horizontal input direction (-1 for left, 1 for right, 0 for neutral)
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# Apply horizontal velocity
		velocity.x = direction * SPEED
		animated_sprite.play("run")
		# Flip sprite based on movement direction
		if direction < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		# Idle animation when not moving
		animated_sprite.play("idle")
		# Apply friction/deceleration
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Apply all physics and handle collisions
	move_and_slide()
