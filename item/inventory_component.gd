# 库存组件
# 附加到实体上，管理一个物品集合。
class_name InventoryComponent
extends Node

# 当库存内容发生变化时发出
signal inventory_changed

# 库存槽位数组，存储 InventoryItem 对象
@export var items: Array[InventoryItem] = []

# 库存的最大槽位数。0 表示无限制。
@export var max_slots: int = 20


# 尝试向库存中添加指定数量的物品。
# 返回 true 如果所有物品都被成功添加。
func add_item(item_data: BaseItemData, quantity: int) -> bool:
	if not item_data:
		push_warning("Attempted to add a null item_data to inventory.")
		return false

	var remaining_quantity = quantity

	# 阶段 1: 尝试堆叠到现有物品上
	if item_data.max_stack_size > 1:
		for item_slot in items:
			if item_slot.item_data == item_data and item_slot.quantity < item_data.max_stack_size:
				var can_add = item_data.max_stack_size - item_slot.quantity
				var to_add = min(remaining_quantity, can_add)
				item_slot.quantity += to_add
				remaining_quantity -= to_add
				if remaining_quantity <= 0:
					break
	
	# 阶段 2: 尝试添加到新的槽位
	while remaining_quantity > 0:
		if max_slots > 0 and items.size() >= max_slots:
			# 库存已满，无法添加新堆栈
			push_warning("Inventory is full. Could not add all items.")
			emit_signal("inventory_changed")
			return false
		
		var to_add = min(remaining_quantity, item_data.max_stack_size)
		var new_item = InventoryItem.new(item_data, to_add)
		items.append(new_item)
		remaining_quantity -= to_add

	emit_signal("inventory_changed")
	return true


# 从指定槽位移除指定数量的物品。
# 如果移除后数量为0，则移除整个槽位。
func remove_item(slot_index: int, quantity: int = 1) -> bool:
	if slot_index < 0 or slot_index >= items.size():
		push_warning("Invalid slot_index for remove_item: " + str(slot_index))
		return false
	
	var item_slot = items[slot_index]
	if item_slot.quantity < quantity:
		# 数量不足，无法移除
		return false
	
	item_slot.quantity -= quantity
	
	if item_slot.quantity <= 0:
		items.pop_at(slot_index)
	
	emit_signal("inventory_changed")
	return true


# 获取指定槽位的物品信息
func get_item(slot_index: int) -> InventoryItem:
	if slot_index >= 0 and slot_index < items.size():
		return items[slot_index]
	return null


# 检查库存中是否有足够数量的特定物品
func has_item(item_data: BaseItemData, quantity: int = 1) -> bool:
	var count = 0
	for item_slot in items:
		if item_slot.item_data == item_data:
			count += item_slot.quantity
			if count >= quantity:
				return true
	return false