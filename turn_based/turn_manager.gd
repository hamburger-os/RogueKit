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
	# 启动主循环处理
	set_process(true)


func _process(_delta):
	set_process(false) # 手动控制循环

	if actors.is_empty():
		print("All actors defeated. Stopping turn processing.")
		return

	# 1. 找到下一个可以行动的 actor
	var actor_to_act: Node = _get_next_actor()
	
	# 2. 让该 actor 执行行动
	turn_counts[actor_to_act] += 1
	var action: BaseAction = await actor_to_act.take_turn()
	
	var energy_cost = ACTION_ENERGY_THRESHOLD
	if action:
		energy_cost = action.energy_cost
		action.execute()
	
	actor_energy[actor_to_act] -= energy_cost
	
	set_process(true) # 为下一帧的下一回合做准备

# 找到下一个能量最先达到阈值的 actor
func _get_next_actor() -> Node:
	while true:
		for actor in actors:
			if actor_energy[actor] >= ACTION_ENERGY_THRESHOLD:
				return actor
		
		# 如果没有 actor 能量足够，则为所有 actor 增加能量，然后重新检查
		_gain_energy_for_all()
	return null # 满足编译器要求

func _gain_energy_for_all():
	for actor in actors:
		var speed = 100.0 # 默认速度
		if "stats_component" in actor and actor.stats_component:
			speed = actor.stats_component.get_stat_value("speed")
		
		actor_energy[actor] += speed


# 实体死亡事件的回调处理函数
func _on_entity_died(entity: Node):
	if actor_energy.has(entity):
		var dead_actor_index = actors.find(entity)
		if dead_actor_index != -1:
			actors.remove_at(dead_actor_index)
			actor_energy.erase(entity)
			turn_counts.erase(entity)