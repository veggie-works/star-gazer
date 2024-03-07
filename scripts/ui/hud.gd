## The player's heads up display
class_name HUD extends BaseUI

## The progress bar displaying the player health 
@onready var health_bar: TextureProgressBar = $margin_container/health_container/health_bar
## The label displaying the current health value out of the max health value
@onready var health_label: Label = health_bar.get_node("health_label")

## The player whose data is displayed in the HUD
var player: Player:
	get:
		var found_players: Array[Node] = get_tree().get_nodes_in_group("players")
		if len(found_players) > 0:
			for found_player in found_players:
				if found_player is Player:
					return found_player
		return null

## The health manager of the associated player
var health_manager: HealthManager:
	get:
		if player == null:
			return null
		var hm: HealthManager = player.get_node("behaviors/health_manager")
		if not hm.took_damage.is_connected(on_damage):
			hm.took_damage.connect(on_damage)
		if not hm.healed.is_connected(on_heal):
			hm.healed.connect(on_heal)
		return hm

## Callback for when the player heals
func on_heal(_heal_amount: float) -> void:
	update_health()

## Callback for when the player takes damage
func on_damage(_attack: Attack) -> void:
	update_health()
	
## Update the health value in the HUD
func update_health() -> void:
	health_bar.value = health_manager.current_health
	health_bar.size.x = health_manager.max_health + health_bar.stretch_margin_left + health_bar.stretch_margin_right
	health_label.text = "%d/%d" % [health_manager.current_health, health_manager.max_health]
	#health_label.position.x -= health_label.size.x / 2
