# 属性资源
# 定义单个属性（如“力量”），包含基础值和计算后的当前值。
class_name Stat
extends Resource

# 当 current_value 发生变化时发出
signal value_changed(old_value, new_value)

# 基础值
@export var base_value: int = 10

# 当前值
var current_value: int:
	get:
		return _calculate_value()

var _modifiers: Array[StatModifier] = []


func add_modifier(modifier):
	var old_value = current_value
	_modifiers.append(modifier)
	emit_signal("value_changed", old_value, current_value)


func remove_modifier(modifier):
	var old_value = current_value
	_modifiers.erase(modifier)
	emit_signal("value_changed", old_value, current_value)


func _calculate_value() -> int:
	var final_value = float(base_value)
	var additive_bonus = 0.0
	var multiplicative_bonus = 1.0

	for modifier in _modifiers:
		match modifier.type:
			StatModifier.ModifierType.ADDITIVE:
				additive_bonus += modifier.value
			StatModifier.ModifierType.MULTIPLICATIVE:
				multiplicative_bonus += modifier.value

	final_value = (base_value + additive_bonus) * multiplicative_bonus
	return int(final_value)