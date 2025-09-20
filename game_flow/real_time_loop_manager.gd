# 实时游戏循环管理器
# 负责驱动实时游戏（如动作Roguelike、竞技场生存）的逻辑。
# 它不依赖离散的回合，而是基于时间来管理行动的触发。
class_name RealTimeLoopManager
extends Node

# 信号：当一个实体的能力冷却时间结束时发出
signal on_cooldown_finished(entity: Node, ability: AbilityData)

# 信号：当一个自动触发的能力准备好执行时发出
signal on_auto_trigger_ready(entity: Node, ability: AbilityData)

# 存储每个实体正在冷却的能力
# 格式: { entity_id: { ability_resource: TimerNode } }
var _cooldowns: Dictionary = {}

# 存储需要自动触发能力的实体
# 格式: { entity_id: { "ability": AbilityData, "interval": float, "time_since_last": float } }
var _auto_triggers: Dictionary = {}


func _process(delta: float):
	# 处理自动触发的能力
	for entity_id in _auto_triggers.keys():
		var trigger_info = _auto_triggers[entity_id]
		trigger_info.time_since_last += delta
		
		if trigger_info.time_since_last >= trigger_info.interval:
			trigger_info.time_since_last = 0.0
			var entity = instance_from_id(entity_id)
			if is_instance_valid(entity):
				var ability: AbilityData = trigger_info.ability
				if is_ability_ready(entity, ability):
					# 发出信号，而不是直接创建和执行Action
					on_auto_trigger_ready.emit(entity, ability)


# 为实体注册一个自动触发的能力
func register_auto_trigger(entity: Node, ability: AbilityData, interval: float):
	var entity_id = entity.get_instance_id()
	_auto_triggers[entity_id] = {
		"ability": ability,
		"interval": interval,
		"time_since_last": 0.0
	}


# 检查一个实体的特定能力是否已冷却完毕
func is_ability_ready(entity: Node, ability: AbilityData) -> bool:
	var entity_id = entity.get_instance_id()
	if not _cooldowns.has(entity_id):
		return true
	
	var ability_id = ability.get_instance_id() # Using instance_id for dictionary keys is still fine
	return not _cooldowns[entity_id].has(ability_id)


# 为一个实体的能力开始计算冷却
func start_cooldown(entity: Node, ability: AbilityData):
	if ability.cooldown <= 0:
		return

	var entity_id = entity.get_instance_id()
	if not _cooldowns.has(entity_id):
		_cooldowns[entity_id] = {}

	var ability_id = ability.get_instance_id()
	
	# 如果已经存在计时器，先移除
	if _cooldowns[entity_id].has(ability_id):
		var old_timer_entry = _cooldowns[entity_id][ability_id]
		old_timer_entry.timer.queue_free()

	# 创建新计时器
	var timer = Timer.new()
	timer.wait_time = ability.cooldown
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	# 存储 Ability 对象本身和计时器
	_cooldowns[entity_id][ability_id] = {
		"ability": ability,
		"timer": timer
	}
	
	# 绑定超时信号
	timer.timeout.connect(
		func():
			_on_timer_timeout(entity_id, ability_id)
	)

# 计时器超时处理
func _on_timer_timeout(entity_id: int, ability_id: int):
	var ability: AbilityData = null
	if _cooldowns.has(entity_id) and _cooldowns[entity_id].has(ability_id):
		var entry = _cooldowns[entity_id].get(ability_id)
		ability = entry.ability
		if is_instance_valid(entry.timer):
			entry.timer.queue_free()
		_cooldowns[entity_id].erase(ability_id)

	var entity = instance_from_id(entity_id)
	if is_instance_valid(entity) and ability:
		on_cooldown_finished.emit(entity, ability)