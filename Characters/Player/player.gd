class_name Player extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label_fruit: Label = $PlayerGUI/VBoxContainer/LabelFruit
@onready var sfx_jump: AudioStreamPlayer2D = $SFXJump
@onready var ray_cast_2d_damage: RayCast2D = $RayCasts/RayCast2DDamage

# Methdos
func _ready() -> void:
	GameInfo.player = self

func _physics_process(delta: float) -> void:
	
	if direction != 0.0:
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	sprite_2d.flip_h = direction < 0 if direction != 0 else sprite_2d.flip_h
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		sfx_jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

# Custom methods
func add_fuit() -> void:
	GameInfo.fruit += 1
	print(GameInfo.fruit)
	update_gui()


func update_gui() -> void:
	label_fruit.text = str(GameInfo.fruit)
