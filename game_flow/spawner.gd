# 生成器
# 接收一个 SpawnProfile 和一个 MapData 对象，并负责根据生成规则在地图的有效位置上生成敌人。
class_name Spawner
extends Node

# 在地图上生成实体
# @param map_data [MapData]: 地图数据，用于确定有效的放置位置。
# @param spawn_profile [SpawnProfile]: 定义要生成的实体及其概率。
# @param parent_node [Node]: 生成的实体将作为此节点的子节点。
func spawn_entities(map_data: MapData, spawn_profile: SpawnProfile, parent_node: Node):
	if not spawn_profile or spawn_profile.spawn_entries.is_empty():
		return

	# 示例逻辑：在每个房间的中心生成一个随机敌人
	for room in map_data.rooms:
		var entity_to_spawn = _pick_entity_from_profile(spawn_profile)
		if entity_to_spawn:
			var spawn_position = room.get_center()
			
			# 从对象池请求一个实例
			# var instance = ObjectPool.request(entity_to_spawn.scene)
			# instance.global_position = spawn_position * TILE_SIZE
			# parent_node.add_child(instance)
			
			print("Spawning " + entity_to_spawn.entity_name + " at " + str(spawn_position))


# 根据权重从 SpawnProfile 中选择一个实体
func _pick_entity_from_profile(spawn_profile: SpawnProfile) -> EntityData:
	var total_weight = 0
	for entry in spawn_profile.spawn_entries:
		total_weight += entry.weight
		
	var random_weight = randi_range(0, total_weight)
	
	for entry in spawn_profile.spawn_entries:
		random_weight -= entry.weight
		if random_weight <= 0:
			return entry.entity_data
			
	return null