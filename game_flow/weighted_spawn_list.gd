# 加权生成列表
# 这个数据资源用于定义一个可以生成的实体类型及其概率的加权列表。
class_name WeightedSpawnList
extends Resource

# 显式预加载以帮助编译器在无头模式下找到类型
const SpawnEntry = preload("res://lib/roguekit/game_flow/spawn_entry.gd")

# 生成条目数组
# 每个条目都是一个 SpawnEntry 资源，定义了要生成的实体及其权重。
@export var spawn_entries: Array[SpawnEntry] = []