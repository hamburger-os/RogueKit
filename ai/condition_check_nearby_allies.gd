# Condition: 检查附近盟友
# 这是一个叶节点，用于检查 actor 周围指定半径内是否存在盟友。
# 这是一个如何扩展自定义 AI 行为节点的示例。
class_name Condition_CheckNearbyAllies
extends BehaviorNode

# 搜索半径（格子数）
@export var radius: int = 3
# 盟友实体应具有的场景组
@export var ally_group: String = "allies"

func tick(actor: Node, blackboard: Dictionary) -> Status:
	var actor_pos = GameManager.get_grid_position(actor)
	
	# 遍历搜索半径内的所有格子
	for y in range(actor_pos.y - radius, actor_pos.y + radius + 1):
		for x in range(actor_pos.x - radius, actor_pos.x + radius + 1):
			# 跳过 actor 自身所在的格子
			if x == actor_pos.x and y == actor_pos.y:
				continue
			
			var entity = GameManager.get_entity_at(Vector2i(x, y))
			if is_instance_valid(entity) and entity != actor:
				# 检查实体是否在指定的盟友组中
				if entity.is_in_group(ally_group):
					# 找到了一个盟友，立即返回成功
					return Status.SUCCESS

	# 没有找到盟友，返回失败
	return Status.FAILURE