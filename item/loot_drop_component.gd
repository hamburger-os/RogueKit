# 掉落组件
# 附加到实体上，负责在实体死亡时生成战利品。
class_name LootDropComponent
extends Node

# 对掉落表资源的引用
@export var loot_table: LootTable

func _ready():
	# 监听所有者的死亡信号
	if get_parent().has_node("HealthComponent"):
		get_parent().get_node("HealthComponent").health_depleted.connect(_on_owner_died)


func _on_owner_died():
	if not loot_table:
		return

	var dropped_items = loot_table.roll_loot()
	# 在这里，我们将实例化掉落的物品到游戏世界中。
	print(get_parent().name + " dropped items: " + str(dropped_items))