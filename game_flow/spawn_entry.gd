# SpawnEntry
# 这个资源定义了生成配置中的一个条目，包含一个实体和它的生成权重。
class_name SpawnEntry
extends Resource

# 对实体数据资源的引用
@export var entity_data: EntityData
# 权重值，用于决定其在生成池中的相对概率
@export var weight: int = 1
