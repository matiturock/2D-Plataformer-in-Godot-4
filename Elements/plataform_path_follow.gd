@tool
extends Node2D

@export_range(0, 1.5) var speed: float = 0.2

@onready var platform: AnimatableBody2D = $Path2D/Platform
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

var is_rigth: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	platform.global_position = path_follow_2d.global_position
	
#	if path_follow_2d.progress_ratio < 1: path_follow_2d.progress_ratio += speed * delta
#	else: path_follow_2d.progress_ratio = 0
	
	if is_rigth: path_follow_2d.progress_ratio += speed * delta
	else: path_follow_2d.progress_ratio -= speed * delta
	
	if path_follow_2d.progress_ratio >= 0.99: is_rigth = false
	if path_follow_2d.progress_ratio <= 0.01: is_rigth = true
