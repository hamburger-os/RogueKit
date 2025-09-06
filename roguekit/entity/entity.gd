# 实体根脚本
# 作为实体场景的根节点脚本，负责将 EntityData 资源分发给它的各个组件。
class_name Entity
extends CharacterBody2D # 或者 Area2D, Node2D, etc.

# 该实体的数据定义
@export var entity_data: EntityData

# 对子组件的引用
@onready var health_component: HealthComponent = $HealthComponent
@onready var stats_component: StatsComponent = $StatsComponent
# ... 其他组件


func _ready():
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


func _on_health_depleted():
	# 实体死亡逻辑
	print(self.name + " has been defeated.")
	# 在实际游戏中，这里可能会播放动画、掉落物品，然后将对象返回到对象池
	queue_free()