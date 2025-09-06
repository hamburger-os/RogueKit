# 掉落表资源
# 定义一个掉落表，其核心是一个 LootEntry 对象的数组。
class_name LootTable
extends Resource

# LootEntry 是一个内联类，用于定义掉落表中的单项。
class LootEntry:
	# 对物品数据资源的引用
	var item_data: BaseItemData
	# 权重值，用于决定其在掉落池中的相对概率
	var weight: int
	# 数量范围
	var min_quantity: int
	var max_quantity: int

# 掉落条目数组
@export var loot_entries: Array[LootEntry] = []


# 根据权重进行一次或多次加权随机抽选，并返回一个包含生成的 InventoryItem 对象的数组。
func roll_loot() -> Array[InventoryItem]:
	var rolled_items: Array[InventoryItem] = []
	# 掉落逻辑将在 v1.1 中实现
	push_warning("LootTable.roll_loot() is not implemented yet.")
	return rolled_items