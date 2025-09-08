# 波次管理器
# 负责加载 WaveProfileData 并根据时间线驱动敌人生成。
class_name WaveManager
extends Node

@export var wave_profile: WaveProfileData
@export var spawner_scene: PackedScene # (需要一个 Spawner 场景用于实例化)

var game_time: float = 0.0
var current_event_index: int = 0
var active_spawners: Dictionary = {} # Key: enemy_key, Value: spawner_node

var events_bus: Node # Added dependency
var game_manager: Node # Added dependency

func set_dependencies(p_events_bus: Node, p_game_manager: Node):
	self.events_bus = p_events_bus
	self.game_manager = p_game_manager

func _ready():
	if wave_profile and not wave_profile.timeline_events.is_empty():
		# 对事件进行排序以确保按时间戳顺序处理
		wave_profile.timeline_events.sort_custom(func(a, b): return a.timestamp < b.timestamp)

func _process(delta: float):
	if not wave_profile or current_event_index >= wave_profile.timeline_events.size():
		return

	game_time += delta
	
	var current_event = wave_profile.timeline_events[current_event_index]
	while game_time >= current_event.timestamp:
		_execute_event(current_event)
		
		current_event_index += 1
		if current_event_index >= wave_profile.timeline_events.size():
			break
		current_event = wave_profile.timeline_events[current_event_index]

func _execute_event(event: WaveEvent):
	match event.action:
		WaveEvent.Action.START_SPAWNING:
			if spawner_scene and not active_spawners.has(event.enemy_key):
				var new_spawner = spawner_scene.instantiate()
				# 注入 GameManager 和 EventsBus
				if new_spawner.has_method("set_dependencies"):
					new_spawner.set_dependencies(events_bus, game_manager)
				
				# 在这里，我们假设 Spawner 节点会负责获取其自身的 spawn_points。
				# 或者，我们可以通过 GameManager 来提供生成点信息。
				# 为了解耦，这里不直接查找 ../Arena。
				
				# Spawner 的 enemy_scene 应该在 Spawner 自身内部根据 enemy_key 来加载，
				# 或者由 WaveManager 预加载并传递 PackedScene。
				# 暂时保留这种方式，但需要注意其局限性。
				new_spawner.enemy_scene = load("res://prefabs/entities/" + event.enemy_key + ".tscn") # 使用 load 替代 preload
				new_spawner.spawn_rate = event.spawn_rate
				new_spawner.max_alive = event.max_alive
				
				add_child(new_spawner)
				active_spawners[event.enemy_key] = new_spawner
		
		WaveEvent.Action.STOP_SPAWNING:
			if active_spawners.has(event.enemy_key):
				var spawner_to_stop = active_spawners[event.enemy_key]
				spawner_to_stop.queue_free()
				active_spawners.erase(event.enemy_key)
				# 考虑如何处理 spawner 已经生成的敌人。它们可能需要被销毁或被标记为非活跃。

		WaveEvent.Action.MODIFY_SPAWN:
			if active_spawners.has(event.enemy_key):
				var spawner_to_modify = active_spawners[event.enemy_key]
				spawner_to_modify.spawn_rate = event.spawn_rate
				spawner_to_modify.max_alive = event.max_alive

		WaveEvent.Action.SPAWN_GROUP:
			if game_manager and event.spawn_group:
				for entity_data in event.spawn_group:
					# 假设 GameManager 或 Spawner 有一个方法来生成单个实体
					# 或者直接在这里实例化实体并添加到场景中
					if entity_data and game_manager.has_method("spawn_single_entity"):
						game_manager.spawn_single_entity(entity_data) # 需要在 GameManager 中实现此方法

		WaveEvent.Action.SET_BOSS_FLAG:
			events_bus.emit_signal("boss_wave_started") # 发出信号通知其他系统

func is_wave_finished() -> bool:
	# 检查所有时间线事件是否都已处理
	var all_events_processed = (current_event_index >= wave_profile.timeline_events.size())
	
	# 检查所有活跃的生成器是否都已完成其任务
	var all_spawners_finished = true
	for enemy_key in active_spawners:
		var spawner_node = active_spawners[enemy_key]
		if spawner_node and spawner_node.is_instance_valid():
			if not spawner_node.is_finished():
				all_spawners_finished = false
				break
		else:
			# 如果 spawner 节点无效，也认为它完成了，因为已经被移除了
			active_spawners.erase(enemy_key)
			
	return all_events_processed and all_spawners_finished