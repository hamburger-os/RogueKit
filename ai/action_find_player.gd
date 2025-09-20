# AI行为：寻找玩家
# 在指定范围内搜索玩家，如果找到，则将其存储在黑板中。
class_name Action_FindPlayer
extends BehaviorNode

# AI的感知范围
@export var detection_range: float = 300.0

# 将找到的玩家存储在黑板中的键
@export var target_key: String = "target"


func tick(actor: Node, blackboard: Dictionary) -> Status:
	# 1. 获取GameManager以找到玩家
	var game_manager = actor.get_node_or_null("/root/GameManager")
	if not game_manager or not is_instance_valid(game_manager.player):
		return Status.FAILURE

	var player = game_manager.player
	
	# 2. 检查距离
	if actor.global_position.distance_to(player.global_position) <= detection_range:
		# 3. 如果在范围内，将玩家存入黑板并返回成功
		print(actor.name + " detected player " + player.name)
		blackboard[target_key] = player
		return Status.SUCCESS
	else:
		# 4. 如果不在范围内，清空黑板中的目标并返回失败
		if blackboard.has(target_key):
			blackboard.erase(target_key)
		return Status.FAILURE