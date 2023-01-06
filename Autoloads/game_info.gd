extends Node

# SFX
@onready var sfx_pickup: AudioStreamPlayer = $SFX/SFX_Pickup
@onready var sfx_jump: AudioStreamPlayer = $SFX/SFX_Jump

# Data
var player: Player = null
var fruit: int = 0 :
	set(value):
		fruit = value
		if player != null:
			player.update_gui()
	get:
		return fruit
