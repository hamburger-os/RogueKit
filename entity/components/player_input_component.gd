# 玩家输入组件
# 监听并转换玩家输入为实体动作（Action）。
class_name PlayerInputComponent
extends Node

# 当玩家决定一个行动时发出
signal action_determined(action)

# 轮到玩家行动时，由 TurnManager 调用
func process_input():
	# 这个函数将在回合制循环中被调用。
	# 在这里，我们将检查输入并发出 action_determined 信号。
	# 对于一个简单的实现，我们现在只处理方向键。
	
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if move_direction != Vector2.ZERO:
		# 注意：MoveAction 还没有被创建，所以这里只是一个占位符。
		# 我们将在实现行动系统时回来完善它。
		var move_action = # MoveAction.new(get_parent(), move_direction)
		# emit_signal("action_determined", move_action)
		pass