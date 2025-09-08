# 波次管理器
# 负责加载 WaveProfileData 并根据时间线驱动敌人生成。
class_name WaveManager
extends Node

@export var wave_profile: WaveProfileData

var game_time: float = 0.0
var current_event_index: int = 0
var active_spawners: Dictionary = {} # Key: enemy_key, Value: spawner_node

# (需要一个 Spawner 场景用于实例化)
@export var spawner_scene: PackedScene 

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
				var arena = get_node_or_null("../Arena") # Assuming Arena is a sibling
				if arena:
					var spawn_points = arena.get_node("SpawnPoints").get_children() # Assuming SpawnPoints is a Node2D with Marker2D children
					new_spawner.spawn_points = spawn_points
				
				new_spawner.enemy_scene = preload("res://prefabs/entities/" + event.enemy_key + ".tscn") # Assuming naming convention
				new_spawner.spawn_rate = event.spawn_rate
				new_spawner.max_alive = event.max_alive
				
				add_child(new_spawner)
				active_spawners[event.enemy_key] = new_spawner
		
		WaveEvent.Action.STOP_SPAWNING:
			if active_spawners.has(event.enemy_key):
				active_spawners[event.enemy_key].queue_free()
				active_spawners.erase(event.enemy_key)

		WaveEvent.Action.MODIFY_SPAWN:
			if active_spawners.has(event.enemy_key):
				pass # active_spawners[event.enemy_key].update_rules(...)

		WaveEvent.Action.SPAWN_GROUP:
			pass # 遍历 event.spawn_group 并立即生成

		WaveEvent.Action.SET_BOSS_FLAG:
			pass # 发出信号或设置全局变量

func is_wave_finished() -> bool:
	# 检查所有时间线事件是否都已处理
	var all_events_processed = (current_event_index >= wave_profile.timeline_events.size())
	
	# 检查所有活跃的生成器是否都已停止生成
	var all_spawners_inactive = true
	for enemy_key in active_spawners:
		var spawner = active_spawners[enemy_key]
		if spawner and spawner.is_instance_valid() and (spawner.get_child_count() > 0 or spawner.spawn_rate > 0): # Check if spawner still has active children or is still spawning
			all_spawners_inactive = false
			break
			
	return all_events_processed and all_spawners_inactive