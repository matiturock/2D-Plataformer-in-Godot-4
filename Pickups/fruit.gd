class_name Fruit extends Area2D

@onready var sfx_pickup: AudioStreamPlayer = $SFXPickup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		sfx_pickup.play()
		atraction_tween(body)
		body.add_fuit()
		

func atraction_tween(body: Node2D):
	var time_tween: float = 0.4
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(false)
	tween.tween_property(self, "global_position", body.global_position, time_tween)
	tween.tween_property(self, "scale", Vector2.ZERO, time_tween)
	tween.tween_callback(self.queue_free)
