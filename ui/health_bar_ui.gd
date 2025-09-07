# Health Bar UI Script
# Attach this script to the root node of a scene containing a ProgressBar.
# Call track_health_component() to bind it to an entity's HealthComponent.
class_name HealthBarUI
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

var _health_component: HealthComponent

# Call this function to link the health bar to a specific entity's health component.
func track_health_component(target_health_component: HealthComponent):
	# Disconnect from previous component if any
	if is_instance_valid(_health_component):
		if _health_component.health_changed.is_connected(_on_health_changed):
			_health_component.health_changed.disconnect(_on_health_changed)

	_health_component = target_health_component

	if not is_instance_valid(_health_component):
		visible = false
		return

	# Connect signals
	_health_component.health_changed.connect(_on_health_changed)
	
	# Initial setup
	progress_bar.max_value = _health_component.max_health
	progress_bar.value = _health_component.current_health
	visible = true

func _on_health_changed(_old_value: int, new_value: int):
	progress_bar.value = new_value