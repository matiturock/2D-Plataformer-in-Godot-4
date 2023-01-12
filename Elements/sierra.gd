@tool
class_name Sierra extends Node2D

@export var damage: int = 3

@onready var off_sprite_2d: Sprite2D = $OffSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	off_sprite_2d.rotate(deg_to_rad(-500 * delta))


func _on_area_2d_player_damage_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
