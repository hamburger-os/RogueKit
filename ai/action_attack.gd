# AI行为：攻击目标
# 从黑板中读取目标，并生成一个AttackAction。
class_name Action_Attack
extends BehaviorNode

# 黑板中存储目标的键
@export var target_key: String = "target"

# 攻击距离：只有当目标在此距离内时才攻击
@export var attack_range: float = 75.0


func tick(actor: Node, blackboard: Dictionary) -> Status:
	# 1. 检查黑板中是否存在目标
	if not blackboard.has(target_key):
		return Status.FAILURE

	var target = blackboard[target_key]
	if not is_instance_valid(target):
		return Status.FAILURE
		
	# 2. 检查攻击距离
	var distance_to_target = actor.global_position.distance_to(target.global_position)
	if distance_to_target > attack_range:
		# 目标太远，无法攻击
		return Status.FAILURE
		
	# 3. 生成并提交AttackAction
	var attack_action = AttackAction.new(target)
	
	# 将Action意图写入黑板
	blackboard["next_action"] = attack_action
	
	print(actor.name + " wants to attack " + target.name)
	return Status.SUCCESS