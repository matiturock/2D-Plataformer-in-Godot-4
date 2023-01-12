class_name State extends Node

var state_machine: StateMachine = null

func state_input(input: InputEvent) -> void:
	pass

func state_process(delta: float) -> void:
	pass

func state_physics_process(delta: float) -> void:
	pass

func state_enter(msg: Dictionary = {}) -> void:
	pass

func state_exit() -> void:
	pass
