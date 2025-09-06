# 库存组件
# 管理一个实体的物品集合，处理物品的添加、移除、堆叠等操作。
class_name InventoryComponent
extends Node

# 当库存内容发生变化时发出
signal inventory_changed

# 库存中的物品
var items: Array[InventoryItem] = []
# 库存容量
@export var capacity: int = 20


# 尝试向库存中添加物品
func add_item(item_data: BaseItemData, quantity: int = 1) -> bool:
	if not item_data:
		return false

	# 尝试堆叠
	for item in items:
		if item.item_data == item_data and item.quantity < item_data.max_stack_size:
			var can_add = item_data.max_stack_size - item.quantity
			var to_add = min(quantity, can_add)
			item.quantity += to_add
			quantity -= to_add
			if quantity == 0:
				emit_signal("inventory_changed")
				return true
	
	# 如果还有剩余，或者无法堆叠，则尝试添加到新槽位
	if items.size() < capacity:
		var new_item = InventoryItem.new(item_data, quantity)
		items.append(new_item)
		emit_signal("inventory_changed")
		return true

	push_warning("Inventory is full!")
	return false


# 移除物品
func remove_item(inventory_item: InventoryItem, quantity: int = 1):
	if not items.has(inventory_item):
		return
		
	inventory_item.quantity -= quantity
	if inventory_item.quantity <= 0:
		items.erase(inventory_item)
		
	emit_signal("inventory_changed")