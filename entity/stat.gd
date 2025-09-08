# 属性资源
# 定义单个属性（如“力量”），包含基础值和计算后的当前值。
class_name Stat
extends Resource

# 当 current_value 发生变化时发出
signal value_changed(old_value, new_value)

# 基础值
@export var base_value: float = 10.0:
	set(value):
		if not is_equal_approx(base_value, value):
			base_value = value
			_is_dirty = true

# 当前值 (使用脏标记缓存)
var current_value: float:
	get:
		if _is_dirty:
			_cached_value = _calculate_value()
			_is_dirty = false
		return _cached_value

var _modifiers: Array[StatModifier] = []
var _is_dirty: bool = true
var _cached_value: float = 0.0


func add_modifier(modifier: StatModifier):
	var old_value = current_value # 获取旧值 (可能会触发一次计算)
	_modifiers.append(modifier)
	_is_dirty = true
	var new_value = current_value # 获取新值 (会触发一次计算)
	if old_value != new_value:
		emit_signal("value_changed", old_value, new_value)


func remove_modifier(modifier: StatModifier):
	var old_value = current_value # 获取旧值
	var index = _modifiers.find(modifier)
	if index != -1:
		_modifiers.remove_at(index)
		_is_dirty = true
		var new_value = current_value # 获取新值
		if old_value != new_value:
			emit_signal("value_changed", old_value, new_value)

#
# 核心计算逻辑
# 计算公式: final_value = (base_value + additive_bonus) * (1.0 + multiplicative_bonus)
# - additive_bonus 是所有加法类型修改器的总和。
# - multiplicative_bonus 是所有乘法类型修改器的总和。
#
func _calculate_value() -> float:
	var final_value = base_value
	var additive_bonus = 0.0
	var multiplicative_bonus = 0.0

	for modifier in _modifiers:
		match modifier.type:
			StatModifier.ModifierType.ADDITIVE:
				additive_bonus += modifier.value
			StatModifier.ModifierType.MULTIPLICATIVE:
				multiplicative_bonus += modifier.value
	
	final_value = (final_value + additive_bonus) * (1.0 + multiplicative_bonus)
	return final_value