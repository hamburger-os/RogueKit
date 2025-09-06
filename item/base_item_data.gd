# 物品数据基类
# 所有物品数据资源的父类，定义了所有物品共有的属性。
class_name BaseItemData
extends Resource

# 物品的唯一ID
@export var id: String = ""
# 物品在UI中显示的名称
@export var item_name: String = ""
# 物品的描述文本
@export var description: String = ""
# 物品的图标
@export var icon: Texture2D
# 最大堆叠数量
@export var max_stack_size: int = 1