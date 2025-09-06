# 生成配置文件
# 这个数据资源用于定义一个关卡或区域中可以生成的实体类型及其概率。
class_name SpawnProfile
extends Resource

# SpawnEntry 是一个内联类，用于定义生成配置中的单项。
class SpawnEntry:
	# 对实体数据资源的引用
	var entity_data: EntityData
	# 权重值，用于决定其在生成池中的相对概率
	var weight: int

# 生成条目数组
@export var spawn_entries: Array[SpawnEntry] = []