# 实体根脚本
# 作为实体场景的根节点脚本，负责将 EntityData 资源分发给它的各个组件。
class_name Entity
extends CharacterBody2D # 或者 Area2D, Node2D, etc.

# 该实体的数据定义
@export var entity_data: EntityData

# 对子组件的引用
var health_component: HealthComponent
var stats_component: StatsComponent
# ... 其他组件


func _ready():
	# 使用 find_child 获取组件引用，更健壮
	health_component = find_child("HealthComponent", true, false)
	stats_component = find_child("StatsComponent", true, false)

	if not entity_data:
		push_warning("EntityData not assigned to " + self.name)
		return
		
	# 分发数据到各个组件
	if health_component:
		health_component.setup(entity_data.max_health)
		
	if stats_component:
		stats_component.setup(entity_data.stats)
		
	# 连接组件信号
	if health_component:
		health_component.health_depleted.connect(_on_health_depleted)
		health_component.damaged.connect(_on_health_damaged)


# 重置实体状态，由对象池调用
func reset_state():
	# 重置生命值
	if health_component:
		health_component.setup(entity_data.max_health)
	
	# TODO: 重置其他组件的状态，例如清除所有临时 StatModifier
	
	# 确保实体在场景树中可见和活动
	# 注意：对象池已经处理了基础的 'visible', 'process', 'physics_process' 的开关
	# 这里主要是重置游戏逻辑相关的状态
	var collision_shape = find_child("CollisionShape2D", true, false)
	if collision_shape:
		collision_shape.disabled = false


# 由 TurnManager 调用
func take_turn() -> BaseAction:
	var action: BaseAction = null
	# 使用 find_child 提高健壮性
	var player_input = find_child("PlayerInputComponent", true, false)
	var ai_component = find_child("AIComponent", true, false)
	
	if player_input:
		action = await player_input.get_action()
	elif ai_component:
		action = ai_component.get_action()
	
	return action


func get_speed() -> float:
	if stats_component:
		# 直接访问全局单例 Roguekit
		return stats_component.get_stat_value(Roguekit.STATS.SPEED)
	return 100.0 # 返回默认速度


func _on_health_depleted():
	# 实体死亡逻辑
	print(self.name + " has been defeated.")
	
	# 直接访问全局事件总线
	Events.entity_died.emit(self)
	
	# 禁用碰撞，防止已死亡的实体继续阻挡路径
	var collision_shape = find_child("CollisionShape2D", true, false)
	if collision_shape:
		collision_shape.disabled = true
		
	# 将对象返回到对象池
	# 注意：检查 ObjectPool 是否存在，以处理非池化实例（例如在测试中）
	if ObjectPool:
		ObjectPool.return_instance(self)
	else:
		# 如果没有对象池，则直接销毁
		push_warning("No ObjectPool available for " + name + ". Freeing instance directly.")
		queue_free()


func _on_health_damaged(amount: int):
	# 将本地的 'damaged' 事件传播到全局事件总线
	# 注意：目前我们将 'source' 设为 null。
	# 一个更完整的实现需要 AttackAction 或类似的东西来传递攻击者。
	# 直接访问全局事件总线
	Events.entity_took_damage.emit(self, amount, null)