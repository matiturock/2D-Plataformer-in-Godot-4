class_name StateMachine extends Node

signal state_transition(satate_name: String)

@export var inital_state: NodePath

@onready var current_state: State = get_node(inital_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await  owner.ready
	
	for child in get_children():
		child.state_machine = self
	
	current_state.state_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state.state_process(delta)

func _unhandled_input(event: InputEvent) -> void:
	current_state.state_input(event)

func transition_state(target_state: String, msg: Dictionary) -> void:
	if not has_node(target_state): return
	
	current_state.state_exit()
	current_state = get_node(target_state)
	current_state.staete_enter(msg)
	
	emit_signal("state_transition", current_state.name)
