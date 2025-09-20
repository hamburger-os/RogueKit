# 装备数据
# 继承自 BaseItemData，用于定义可穿戴的装备，如盔甲、头盔、饰品等。
class_name EquipmentData
extends BaseItemData

# 装备槽位
# 使用字符串来定义槽位，例如 "head", "chest", "ring_1"
# 具体的槽位由游戏项目自行定义和管理。
@export var equip_slot: String = "unequippable"

# 装备该物品时应用的属性修改器数组
@export var stat_modifiers: Array[StatModifier] = []