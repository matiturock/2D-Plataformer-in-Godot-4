class_name EnemyPig extends CharacterBase

enum STATE { WALK, ANGRY, DEAD }

var direction: float = -1.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_change_direction: bool = true
var current_state: STATE
var target_player: Player = null

@export var speed_boost: float = 120

@onready var ray_cast_2d_ground: RayCast2D = $RayCasts/RayCast2DGround
@onready var ray_cast_2d_wall: RayCast2D = $RayCasts/RayCast2DWall
@onready var change_direction_timer: Timer = $RayCasts/ChangeDirectionTimer
@onready var ray_cast_2d_player_detector: RayCast2D = $RayCasts/RayCast2DPlayerDetector
@onready var area_2d_player_damage: Area2D = $Area2DPlayerDamage

func _ready() -> void:
	state_controller(STATE.WALK)

func _physics_process(_delta: float) -> void:
	velocity.x = direction * speed
	
	if not is_on_floor():
		velocity.y += gravity
	
	move_and_slide()

func _process(_delta: float) -> void:
	# Enemy descts player
	if ray_cast_2d_player_detector.is_colliding() and target_player == null:
		if ray_cast_2d_player_detector.get_collider() is Player:
			target_player = ray_cast_2d_player_detector.get_collider()
			state_controller(STATE.ANGRY)
	
	if current_state == STATE.ANGRY and target_player != null:
		# Enemiy moves to player
		direction = global_position.direction_to(target_player.global_position).x
	
	if can_change_direction:
		if ray_cast_2d_wall.is_colliding() or not ray_cast_2d_ground.is_colliding():
			can_change_direction = false
			change_direction_timer.start()
			ray_cast_2d_wall.target_position.y *= -1
			ray_cast_2d_player_detector.target_position.x *= -1
			direction *= -1
	
	sprite_2d.flip_h = direction > 0

func _on_change_direction_timer_timeout() -> void:
	can_change_direction = true

func state_controller(new_state: STATE) -> void:
	match new_state:
		STATE.WALK:
			animation_player.play("walk")
		STATE.ANGRY:
			animation_player.play("run_angry")
			speed = speed_boost
		STATE.DEAD:
			collision_shape_2d.set_deferred("disabled", true)
			area_2d_player_damage.set_deferred("disabled", true)
			GameInfo.sfx_hit.play()
			animation_player.play("hurt")
			await animation_player.animation_finished
			queue_free()
		_:
			printerr("Enemy state error")

func take_damage(damage: int = 1):
	life -= damage
	GameInfo.sfx_hit.play()
	if life <= 0:
		state_controller(STATE.DEAD)


func _on_area_2d_player_damage_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
