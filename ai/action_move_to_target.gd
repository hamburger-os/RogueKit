# AI行为：移动到目标
# 从黑板中读取目标，并生成一个MoveAction来向目标移动一步。
class_name Action_MoveToTarget
extends BehaviorNode

# 黑板中存储目标的键
@export var target_key: String = "target"

# 停止距离：当与目标的距离小于此值时，停止移动并返回成功
@export var stop_distance: float = 50.0


func tick(actor: Node, blackboard: Dictionary) -> Status:
	# 1. 检查黑板中是否存在目标
	if not blackboard.has(target_key):
		return Status.FAILURE

	var target = blackboard[target_key]
	if not is_instance_valid(target):
		return Status.FAILURE
		
	# 2. 检查距离
	var distance_to_target = actor.global_position.distance_to(target.global_position)
	if distance_to_target <= stop_distance:
		# 已经足够近，无需移动
		return Status.SUCCESS
		
	# 3. 计算方向
	# 在网格游戏中，我们通常需要将方向归一化为8个方向之一
	# 这里为了简化，我们只计算大致方向，并假设MoveAction会处理网格对齐
	var direction_vector = (target.global_position - actor.global_position).normalized()
	var grid_direction = Vector2i(round(direction_vector.x), round(direction_vector.y))
	
	if grid_direction == Vector2i.ZERO:
		# 避免原地不动
		return Status.FAILURE

	# 4. 生成并提交MoveAction
	var move_action = MoveAction.new(grid_direction)
	
	# 行为树节点不直接执行Action，而是将其返回给AIComponent
	# AIComponent再提交给TurnManager或相应的循环管理器
	# 我们在黑板中设置一个"next_action"键来传递这个意图
	blackboard["next_action"] = move_action
	
	print(actor.name + " wants to move towards " + target.name)
	return Status.SUCCESS