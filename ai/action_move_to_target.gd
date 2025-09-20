# Action: 移动向目标
# 这是一个叶节点，用于生成一个朝向黑板中目标实体的 MoveAction。
class_name Action_MoveToTarget
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

	var actor_pos = GameManager.get_grid_position(actor)
	var target_pos = GameManager.get_grid_position(target)
	
	var direction = (target_pos - actor_pos)
	
	# 简单的方向计算：选择X或Y轴上差异更大的一轴进行移动
	var move_vector = Vector2i.ZERO
	if abs(direction.x) > abs(direction.y):
		move_vector.x = sign(direction.x)
	else:
		move_vector.y = sign(direction.y)

	if move_vector == Vector2i.ZERO:
		# 已经到达目标
		return Status.FAILURE

	# 创建 MoveAction 并放入黑板
	blackboard[action_key] = MoveAction.new(move_vector)
	return Status.SUCCESS