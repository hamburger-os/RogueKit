# AI 组件
# 负责实体的AI行为逻辑。
# v1.0 版本实现简单的“追逐并攻击”逻辑。
class_name AIComponent
extends Node

# 当AI决定一个行动时发出
signal action_determined(action)

enum AIState {IDLE, CHASING}

var _state: AIState = AIState.IDLE
var _target: Node = null


# 轮到AI行动时，由 TurnManager 调用
func process_ai():
	# 1. 寻找目标 (通常是玩家)
	_find_target()
	
	# 2. 根据状态决定行动
	match _state:
		AIState.IDLE:
			# 闲置状态：随机移动
			var random_direction = Vector2i(randi_range(-1, 1), randi_range(-1, 1))
			if random_direction != Vector2i.ZERO:
				emit_signal("action_determined", MoveAction.new(get_parent(), random_direction))
			else: # 如果随机到(0,0)，就待在原地
				emit_signal("action_determined", null) # null action means wait
		
		AIState.CHASING:
			# 追逐状态：向目标移动或攻击
			var owner = get_parent()
			var direction_to_target = (owner.global_position - _target.global_position).normalized()
			
			# 检查是否在攻击范围内
			if owner.global_position.distance_to(_target.global_position) < 64: # 假设攻击范围是64像素
				emit_signal("action_determined", AttackAction.new(owner, _target))
			else:
				# 向目标移动
				var move_direction = Vector2i(int(direction_to_target.x), int(direction_to_target.y))
				emit_signal("action_determined", MoveAction.new(owner, move_direction))


func _find_target():
	# 在真实游戏中，这里会使用更复杂的逻辑（如区域检测、视野）来找到玩家。
	# 为了简单起见，我们假设它总是能找到一个名为 "Player" 的节点。
	_target = get_tree().get_first_node_in_group("player")
	if is_instance_valid(_target):
		_state = AIState.CHASING
	else:
		_state = AIState.IDLE