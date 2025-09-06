# 装备数据
# 装备类物品的基类。
class_name EquipmentData
extends BaseItemData

# 装备槽位
enum EquipSlot {HEAD, CHEST, LEGS, WEAPON}
@export var equip_slot: EquipSlot

# 装备时应用的属性修改器
@export var stat_modifiers: Array[StatModifier] = []