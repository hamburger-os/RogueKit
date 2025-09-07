# 实体数据
# 这个资源定义了一个实体的所有数据属性，如名称、生命值、统计数据等。
# 它是实体-组件-数据架构的核心。
class_name EntityData
extends Resource

# 实体的名称
@export var entity_name: String = "Entity"

@export_group("Scene")
@export var scene: PackedScene # 实体对应的场景文件

# 生命值相关
@export_group("Health")
@export var max_health: int = 100

# 统计数据相关
@export_group("Stats")
@export var stats: Dictionary = {} # e.g., {"strength": 10, "speed": 100}