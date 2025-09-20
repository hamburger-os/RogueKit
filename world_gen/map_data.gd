# 抽象地图数据
# 这是地图的纯数据表示，与 TileMap 的视觉渲染分离。
# 生成算法在此数据结构上运行，以提高性能和可测试性。
class_name MapData
extends Resource

# 地图的宽度和高度
@export var width: int
@export var height: int

# 定义瓦片类型的枚举
enum TileType {WALL, FLOOR}

# 二维数组，存储每个网格的瓦片类型
var tiles: Array = []

# 用于存储已识别的房间等元数据
var rooms: Array = []


# 初始化地图数据，用指定的瓦片类型填充整个地图
func create(p_size: Vector2i, p_initial_tile: TileType):
	self.width = p_size.x
	self.height = p_size.y
	tiles.resize(width * height)
	tiles.fill(p_initial_tile)


# 设置指定坐标的瓦片类型
func set_tile(x: int, y: int, type: TileType):
	if _is_in_bounds(x, y):
		tiles[y * width + x] = type


# 获取指定坐标的瓦片类型
func get_tile(x: int, y: int) -> TileType:
	if _is_in_bounds(x, y):
		return tiles[y * width + x]
	return TileType.WALL


# 检查坐标是否在地图边界内
func _is_in_bounds(x: int, y: int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < height