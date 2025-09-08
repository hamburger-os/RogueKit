# 掉落表资源
# 定义一个掉落表，其核心是一个 LootEntry 对象的数组。
class_name LootTable
extends Resource

# LootEntry 是一个内联类，用于定义掉落表中的单项。
class LootEntry:
	@export var item_data: BaseItemData # 对物品数据资源的引用
	@export var weight: int = 1 # 权重值，用于决定其在掉落池中的相对概率
	@export var min_quantity: int = 1 # 数量范围
	@export var max_quantity: int = 1

# 掉落条目数组
@export var loot_entries: Array = [] # Removed LootEntry type hint for export


# 根据权重进行一次或多次加权随机抽选，并返回一个包含生成的 InventoryItem 对象的数组。
# 注意：当前实现为每次调用只掉落一个物品堆栈。可以扩展为支持掉落多次。
func roll_loot() -> Array[InventoryItem]:
	var rolled_items: Array[InventoryItem] = []
	if loot_entries.is_empty():
		return rolled_items

	# 1. 计算总权重
	var total_weight: int = 0
	for entry in loot_entries:
		total_weight += entry.weight

	if total_weight <= 0:
		push_warning("LootTable has zero total weight.")
		return rolled_items

	# 2. 加权随机选择
	var random_roll = randi_range(1, total_weight) # 随机数范围 [1, total_weight]
	var selected_entry: LootEntry = null

	for entry in loot_entries:
		random_roll -= entry.weight
		if random_roll <= 0:
			selected_entry = entry
			break
	
	# 3. 创建物品实例
	if selected_entry and selected_entry.item_data:
		# 计算掉落数量
		var quantity = randi_range(selected_entry.min_quantity, selected_entry.max_quantity)
		if quantity > 0:
			rolled_items.append(InventoryItem.new(selected_entry.item_data, quantity))
	else:
		push_warning("Loot roll failed to select an item, check weights or table configuration.")

	return rolled_items