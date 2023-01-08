class_name Player extends CharacterBody2D

enum STATE { LIVE, HURT, DEAD, INVINCIBLE }

@export var life: int = 3:
	set(value):
		life = value
		if life < 0:
			life = 0
	get:
		return life
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 0.0
var current_state: STATE
var can_take_input: bool = true:
	set(value):
		can_take_input = value

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sfx_jump: AudioStreamPlayer2D = $SFXJump
@onready var ray_casts_damage: Node2D = $RayCastsDamage
@onready var player_gui: CanvasLayer = $PlayerGUI
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Methdos
func _ready() -> void:
	current_state = STATE.LIVE
	update_gui()
	GameInfo.player = self

func _process(delta: float) -> void:
	for ray in ray_casts_damage.get_children():
		if ray.is_colliding():
			var enemy: Node2D = ray.get_collider()
			if enemy != null and enemy.has_method("take_damage"):
				enemy.take_damage()
				velocity.y = jump_velocity
				sfx_jump.play()

func _physics_process(delta: float) -> void:
	
	sprite_2d.flip_h = direction < 0 if direction != 0 else sprite_2d.flip_h
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not can_take_input:
		return
	
	if velocity.x == 0:
		animation_player.play("idle")
	else:
		animation_player.play("walk")
	
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
	GameInfo.fruits_number += 1
	print(GameInfo.fruits_number)
	update_gui()

func state_controller(new_state: STATE) -> void:
	match new_state:
		STATE.LIVE:
			can_take_input = true
		STATE.HURT:
			can_take_input = false
			animation_player.play("hurt")
			await animation_player.animation_finished
			state_controller(STATE.LIVE)
		STATE.INVINCIBLE:
			can_take_input = true
			var current_modulate: Color = sprite_2d.modulate
			sprite_2d.modulate = Color.RED
			await get_tree().create_timer(1.5).timeout
			sprite_2d.modulate = current_modulate
			state_controller(STATE.LIVE)
		STATE.DEAD:
			get_tree().reload_current_scene()
		_:
			printerr("Error in player state")

func update_gui() -> void:
	player_gui.life_number = life
	player_gui.fruits_number = GameInfo.fruits_number

func take_damage(damage: int = 1) -> void:
	GameInfo.sfx_hit.play()
	life -= damage
	state_controller(STATE.HURT)
	update_gui()
	
	if life <= 0:
		state_controller(STATE.DEAD)
