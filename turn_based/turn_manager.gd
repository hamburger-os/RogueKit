# 回合制管理器
# 负责协调游戏的回合流程，维护一个行动队列，并决定当前轮到哪个实体行动。
# 实现基于能量/行动点系统 (设计文档 6.1 节)。
class_name TurnManager
extends Node

# 实体执行行动所需的最小能量阈值。
const ACTION_ENERGY_THRESHOLD: int = 100

# 行动队列，存储了所有可行动的实体
var actors: Array[Node] = []
# 存储每个实体的当前能量 { entity_node: energy_value }
var actor_energy: Dictionary = {}
var turn_counts: Dictionary = {} # For testing purposes { entity_node: count }
var _is_running: bool = false


func _ready():
	pass # 连接信号的逻辑将由注入者（如Game.gd）处理


# 注册一个实体到行动队列
func register_actor(actor: Node):
	if not actors.has(actor):
		actors.append(actor)
		actor_energy[actor] = 0 # 初始化能量
		turn_counts[actor] = 0 # 初始化回合计数


# 开始回合循环
func start_game():
	if actors.is_empty():
		push_warning("TurnManager started with no actors registered.")
		return
	if _is_running:
		return
		
	_is_running = true
	_turn_loop()


# 主游戏循环
func _turn_loop():
	while _is_running:
		if actors.is_empty():
			print("All actors defeated. Stopping turn processing.")
			stop_game()
			return

		# 1. 找到下一个可以行动的 actor
		var actor_to_act: Node = _get_next_actor()
		
		if not is_instance_valid(actor_to_act):
			# 如果在获取能量的过程中，actor 失效了（例如被其他效果杀死），则跳过
			continue

		# 2. 让该 actor 执行行动
		turn_counts[actor_to_act] += 1
		var action: BaseAction = await actor_to_act.take_turn()
		
		# 在等待输入后，再次检查 actor 是否仍然有效
		if not is_instance_valid(actor_to_act):
			continue
			
		var energy_cost = ACTION_ENERGY_THRESHOLD
		if action:
			energy_cost = action.energy_cost
			action.execute()
		
		actor_energy[actor_to_act] -= energy_cost


# 找到下一个能量最先达到阈值的 actor
func _get_next_actor() -> Node:
	while true:
		# 检查是否有 actor 能量足够
		for actor in actors:
			if actor_energy[actor] >= ACTION_ENERGY_THRESHOLD:
				return actor
		
		# 如果没有，则为所有 actor 增加能量
		var was_energy_gained = _gain_energy_for_all()
		if not was_energy_gained:
			# 如果没有一个 actor 能获得能量（例如所有 actor 速度为0），则中断循环防止游戏冻结
			push_error("No actor could gain energy. Turn loop is stuck. Stopping game.")
			stop_game()
			return null

	return null # 满足编译器要求

func _gain_energy_for_all() -> bool:
	var any_energy_gained = false
	for actor in actors:
		# 解耦：调用实体自己的方法来获取速度
		var speed = actor.get_speed()
		if speed > 0:
			any_energy_gained = true
			actor_energy[actor] += speed
	return any_energy_gained


# 停止回合循环
func stop_game():
	_is_running = false


# 清空所有已注册的 actor，用于开始新游戏
func clear_actors():
	actors.clear()
	actor_energy.clear()
	turn_counts.clear()


# 实体死亡事件的回调处理函数
func _on_entity_died(entity: Node):
	if actor_energy.has(entity):
		var dead_actor_index = actors.find(entity)
		if dead_actor_index != -1:
			actors.remove_at(dead_actor_index)
			actor_energy.erase(entity)
			turn_counts.erase(entity)