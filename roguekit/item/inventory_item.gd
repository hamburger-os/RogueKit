# 库存物品
# 一个轻量级的数据对象，用于表示库存中的单个物品实例。
# 它遵循享元模式，通过引用 ItemData 来节省内存。
class_name InventoryItem
extends Object

# 对物品数据资源的引用
var item_data: BaseItemData
# 当前的堆叠数量
var quantity: int

func _init(p_item_data: BaseItemData, p_quantity: int = 1):
	self.item_data = p_item_data
	self.quantity = p_quantity