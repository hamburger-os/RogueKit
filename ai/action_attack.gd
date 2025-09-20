# Action: 攻击目标
# 这是一个叶节点，用于生成一个攻击黑板中目标实体的 AttackAction。
class_name Action_Attack
extends BehaviorNode

# 从黑板读取的目标键
@export var target_key: String = "target_entity"
# 要写入黑板的行动键
@export var action_key: String = "action"

func tick(actor: Node, blackboard: Dictionary) -> Status:
	if not blackboard.has(target_key):
		return Status.FAILURE

	var target = blackboard[target_key]
	if not is_instance_valid(target):
		return Status.FAILURE

	# 简单的距离检查：只有当目标在邻近格时才攻击
	var actor_pos = GameManager.get_grid_position(actor)
	var target_pos = GameManager.get_grid_position(target)
	
	var distance = actor_pos.distance_to(target_pos)
	if distance > 1.5: # 大于根号2，即不在8个相邻格内
		return Status.FAILURE

	# 创建 AttackAction 并放入黑板
	blackboard[action_key] = AttackAction.new(target)
	return Status.SUCCESS