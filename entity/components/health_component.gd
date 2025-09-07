# 生命值组件
# 管理生命值 (HP)、承受伤害、死亡事件。
class_name HealthComponent
extends Node

# 当生命值耗尽时发出
signal health_depleted
# 当生命值发生变化时发出
signal health_changed(old_value, new_value)

@export var max_health: int = 100

var current_health: int:
	get:
		return _current_health
	set(value):
		var old_health = _current_health
		_current_health = clamp(value, 0, max_health)
		if _current_health != old_health:
			emit_signal("health_changed", old_health, _current_health)
			if _current_health == 0:
				emit_signal("health_depleted")

var _current_health: int


func _ready():
	self.current_health = max_health


# 初始化组件
func setup(p_max_health: int):
	self.max_health = p_max_health
	self.current_health = p_max_health


# 承受伤害
func take_damage(amount: int):
	self.current_health -= amount


# 治疗
func heal(amount: int):
	self.current_health += amount