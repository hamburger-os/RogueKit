# 消耗品数据
# 继承自 BaseItemData，用于定义消耗品，如药水、卷轴等。
class_name ConsumableData
extends BaseItemData

# 使用该物品时应用的效果数组
# 例如，一个治疗药水可能包含一个 "HealEffect" 资源。
@export var effects: Array[EffectData] = []