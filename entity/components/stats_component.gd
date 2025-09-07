# 属性组件
# 持有并管理一个由 Stat 资源构成的字典，处理所有数值属性。
class_name StatsComponent
extends Node

var stats: Dictionary = {} # Key: stat_name (String), Value: stat_resource (Stat)


var _temp_modifiers: Array = [] # 存储 { "stat_name": String, "modifier": StatModifier, "timer": float }


func _process(delta: float):
	# 反向遍历以安全地移除元素
	for i in range(_temp_modifiers.size() - 1, -1, -1):
		var entry = _temp_modifiers[i]
		entry.timer -= delta
		if entry.timer <= 0:
			remove_modifier(entry.stat_name, entry.modifier)
			_temp_modifiers.pop_at(i)


# 初始化组件
func setup(stats_data: Dictionary):
	for stat_name in stats_data:
		var base_value = stats_data[stat_name]
		var new_stat = Stat.new()
		new_stat.base_value = base_value
		stats[stat_name] = new_stat


# 获取一个属性资源
func get_stat(stat_name: String) -> Stat:
	if stats.has(stat_name):
		return stats[stat_name]
	return null


# 获取一个属性的当前值
func get_stat_value(stat_name: String) -> int:
	var stat = get_stat(stat_name)
	if stat:
		return stat.current_value
	push_warning("Stat not found: " + stat_name)
	return 0


# 为一个属性添加修改器
func add_modifier(stat_name: String, modifier: StatModifier):
	var stat = get_stat(stat_name)
	if stat:
		stat.add_modifier(modifier)
		if modifier.duration > 0:
			_temp_modifiers.append({
				"stat_name": stat_name,
				"modifier": modifier,
				"timer": modifier.duration
			})


# 从一个属性移除修改器
func remove_modifier(stat_name: String, modifier: StatModifier):
	var stat = get_stat(stat_name)
	if stat:
		stat.remove_modifier(modifier)