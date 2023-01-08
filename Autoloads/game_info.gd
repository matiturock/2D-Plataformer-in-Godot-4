extends Node

# SFX
@onready var sfx_pickup: AudioStreamPlayer = $SFX/SFX_Pickup
@onready var sfx_jump: AudioStreamPlayer = $SFX/SFX_Jump
@onready var sfx_hit: AudioStreamPlayer = $SFX/SFX_Hit

# Data
var player: Player = null
var fruits_number: int = 0 :
	set(value):
		fruits_number = value
		if player != null:
			player.update_gui()
			sfx_pickup.play()
	get:
		return fruits_number
