# 属性组件
# 持有并管理一个由 Stat 资源构成的字典，处理所有数值属性。
class_name StatsComponent
extends Node

var stats: Dictionary = {} # Key: stat_name (String), Value: stat_resource (Stat)

var _realtime_modifiers: Array = [] # 存储 { "stat_name": String, "modifier": StatModifier, "timer": float }
var _turn_based_modifiers: Array = [] # 存储 { "stat_name": String, "modifier": StatModifier, "turns_left": int }


func _process(delta: float):
	# 处理实时修改器
	for i in range(_realtime_modifiers.size() - 1, -1, -1):
		var entry = _realtime_modifiers[i]
		entry.timer -= delta
		if entry.timer <= 0:
			remove_modifier(entry.stat_name, entry.modifier)
			_realtime_modifiers.pop_at(i)

# TODO: 连接到回合结束信号，处理回合制修改器
# func _on_turn_ended():
# 	for i in range(_turn_based_modifiers.size() - 1, -1, -1):
# 		var entry = _turn_based_modifiers[i]
# 		entry.turns_left -= 1
# 		if entry.turns_left <= 0:
# 			remove_modifier(entry.stat_name, entry.modifier)
# 			_turn_based_modifiers.pop_at(i)


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
func get_stat_value(stat_name: String) -> float:
	var stat = get_stat(stat_name)
	if stat:
		return stat.current_value
	push_warning("Stat not found: " + stat_name)
	return 0.0


# 为一个属性添加修改器
func add_modifier(stat_name: String, modifier: StatModifier):
	var stat = get_stat(stat_name)
	if not stat:
		return

	stat.add_modifier(modifier)

	match modifier.duration_type:
		StatModifier.DurationType.REALTIME:
			if modifier.duration > 0:
				_realtime_modifiers.append({
					"stat_name": stat_name,
					"modifier": modifier,
					"timer": modifier.duration
				})
		StatModifier.DurationType.TURNS:
			if modifier.duration > 0:
				_turn_based_modifiers.append({
					"stat_name": stat_name,
					"modifier": modifier,
					"turns_left": int(modifier.duration)
				})


# 从一个属性移除修改器
func remove_modifier(stat_name: String, modifier: StatModifier):
	var stat = get_stat(stat_name)
	if stat:
		stat.remove_modifier(modifier)
	
	# 确保从临时修改器列表中移除对应的条目
	_realtime_modifiers.erase({"stat_name": stat_name, "modifier": modifier, "timer": modifier.duration})
	_turn_based_modifiers.erase({"stat_name": stat_name, "modifier": modifier, "turns_left": int(modifier.duration)})