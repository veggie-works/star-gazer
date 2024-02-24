## Player-specific finite state machine
class_name PlayerFSM extends StateMachine

## The player's local combo manager
@onready var combo_manager: ComboManager = %combo_manager
## The player's local weapon manager
@onready var weapon_manager: WeaponManager = %weapon_manager


func _ready() -> void:
	combo_manager.combo_started.connect(on_combo_start)
	combo_manager.maxed_combo.connect(on_maxed_combo)
	super._ready()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		weapon_manager.attack()
	check_perfect_inputs(event)
	current_state.input(event)

## Check whether a perfect input has been executed
func check_perfect_inputs(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if AudioManager.perfect_attacked:
			combo_manager.increment_combo()
		else:
			combo_manager.reset_combo()

## Callback for when a combo is started
func on_combo_start() -> void:
	print("COMBO START")

## Callback for when the player maxes out a combo
func on_maxed_combo() -> void:
	print("MAXED COMBO")
