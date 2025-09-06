# 回合制管理器
# 负责协调游戏的回合流程，维护一个行动队列，并决定当前轮到哪个实体行动。
class_name TurnManager
extends Node

# 行动队列，存储了所有可行动的实体
var _action_queue: Array = []
# 当前正在行动的实体
var _current_actor: Node = null

# 注册一个实体到行动队列
func register_actor(actor):
	if not _action_queue.has(actor):
		_action_queue.append(actor)
		# 简单的实现：给每个实体一个 PlayerInputComponent 或 AIComponent
		# 这样我们就可以连接到它们的 action_determined 信号
		if actor.has_node("PlayerInputComponent"):
			actor.get_node("PlayerInputComponent").action_determined.connect(_on_action_determined)
		elif actor.has_node("AIComponent"):
			actor.get_node("AIComponent").action_determined.connect(_on_action_determined)


# 开始回合循环
func start_turn_loop():
	_process_next_turn()


func _process_next_turn():
	if _action_queue.is_empty():
		return

	_current_actor = _action_queue.pop_front()
	_action_queue.append(_current_actor) # Move to the back of the queue
	
	# 请求行动
	if _current_actor.has_node("PlayerInputComponent"):
		_current_actor.get_node("PlayerInputComponent").process_input()
	elif _current_actor.has_node("AIComponent"):
		_current_actor.get_node("AIComponent").process_ai()


func _on_action_determined(action):
	# 在这里，我们将执行 action.execute()
	# 并处理能量消耗等逻辑。
	# 目前，我们只是简单地继续下一个回合。
	print("Action determined by " + _current_actor.name)
	# action.execute()
	
	_process_next_turn()