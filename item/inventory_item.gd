# 库存物品
# 这是一个轻量级的对象，用于在库存中表示一个物品堆栈。
# 它包含对物品数据资源的引用和当前的堆叠数量。
class_name InventoryItem
extends Object

var item_data: BaseItemData
var quantity: int

# 构造函数
func _init(p_item_data: BaseItemData, p_quantity: int):
	self.item_data = p_item_data
	self.quantity = p_quantity