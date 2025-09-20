# 掉落组件
# 附加到实体上，负责在实体死亡时生成战利品。
class_name LootDropComponent
extends Node

# 对掉落表资源的引用
@export var loot_table: LootTable

# 用于在世界中代表掉落物的场景。
# 该场景的根节点脚本应该有一个 `setup(p_dropped_items: Array[InventoryItem])` 方法。
@export var loot_scene: PackedScene


func _ready():
	# 监听所有者的死亡信号
	var owner = get_parent()
	if owner and owner.has_node("HealthComponent"):
		owner.get_node("HealthComponent").health_depleted.connect(_on_owner_died)


func _on_owner_died():
	if not loot_table or not loot_scene:
		return

	var dropped_items: Array[InventoryItem] = loot_table.roll_loot()
	if dropped_items.is_empty():
		return
		
	var owner = get_parent()
	
	# 实例化战利品场景
	var loot_instance = loot_scene.instantiate()
	
	# 设置掉落物数据
	if loot_instance.has_method("setup"):
		loot_instance.setup(dropped_items)
	else:
		push_warning("Loot scene " + loot_scene.resource_path + " does not have a setup() method.")

	# 将掉落物放置在死亡实体的位置
	loot_instance.global_position = owner.global_position
	
	# 将掉落物添加到场景树中
	# 最好是添加到一个专门的 "loot" 图层/节点下，这里我们暂时添加到 owner 的父节点下
	if owner.get_parent():
		owner.get_parent().add_child(loot_instance)
	else:
		push_error("LootDropComponent's owner has no parent. Cannot spawn loot.")
		loot_instance.queue_free()

	print(owner.name + " dropped items: " + str(dropped_items))