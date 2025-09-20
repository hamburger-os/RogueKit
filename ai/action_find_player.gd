# Action: 查找玩家
# 这是一个叶节点，用于在黑板中设置目标为玩家实体。
class_name Action_FindPlayer
extends BehaviorNode

# 要写入黑板的目标键
@export var target_key: String = "target_entity"

func tick(actor: Node, blackboard: Dictionary) -> Status:
	var player_entity = GameManager.player_entity
	
	if is_instance_valid(player_entity):
		blackboard[target_key] = player_entity
		return Status.SUCCESS
	else:
		return Status.FAILURE