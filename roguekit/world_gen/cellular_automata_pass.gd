# 元胞自动机生成通道
# 使用元胞自动机算法来创建自然的、不规则的洞穴系统。
class_name CellularAutomataPass
extends GenerationPass

# 初始地面概率
@export var ground_chance: float = 0.45
# 迭代次数
@export var iterations: int = 5
# 邻居阈值，少于这个数量邻居的墙会变成地面
@export var birth_limit: int = 4
# 邻居阈值，少于这个数量邻居的地面会变成墙
@export var death_limit: int = 3

var _rng = RandomNumberGenerator.new()


func generate(map_data: MapData) -> MapData:
	# 1. 随机初始化地图
	for y in range(map_data.height):
		for x in range(map_data.width):
			if _rng.randf() < ground_chance:
				map_data.set_tile(x, y, MapData.TileType.FLOOR)
			else:
				map_data.set_tile(x, y, MapData.TileType.WALL)

	# 2. 运行迭代
	for i in range(iterations):
		_simulation_step(map_data)

	return map_data


func _simulation_step(map_data: MapData):
	var new_tiles = map_data.tiles.duplicate()
	
	for y in range(map_data.height):
		for x in range(map_data.width):
			var neighbors = _count_alive_neighbors(map_data, x, y)
			var current_tile_index = y * map_data.width + x
			var current_tile = map_data.tiles[current_tile_index]
			
			if current_tile == MapData.TileType.WALL:
				if neighbors < birth_limit:
					new_tiles[current_tile_index] = MapData.TileType.FLOOR
			else:
				if neighbors < death_limit:
					new_tiles[current_tile_index] = MapData.TileType.WALL

	map_data.tiles = new_tiles


func _count_alive_neighbors(map_data: MapData, x: int, y: int) -> int:
	var count = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue
				
			var neighbor_x = x + i
			var neighbor_y = y + j
			
			if not map_data._is_in_bounds(neighbor_x, neighbor_y):
				# 边界外的视为墙
				count += 1
			elif map_data.get_tile(neighbor_x, neighbor_y) == MapData.TileType.WALL:
				count += 1
				
	return count