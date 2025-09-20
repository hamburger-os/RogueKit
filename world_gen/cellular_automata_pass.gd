# 元胞自动机生成通道
# 使用元胞自动机算法生成自然的、类似洞穴的地图结构。
class_name CellularAutomataPass
extends GenerationPass

# --- 可配置参数 ---

# 初始填充时，一个格子是地面（而非墙壁）的概率。
# 推荐值: 0.4 - 0.6
@export var ground_chance: float = 0.45

# 平滑地图的迭代次数。次数越多，地图越平滑，但计算成本也越高。
# 推荐值: 3 - 8
@export var iterations: int = 5

# 在一次迭代中，如果一个墙壁格子周围的地面邻居数量大于等于此值，它就会变成地面。
# 推荐值: 5
@export var birth_threshold: int = 5

# 在一次迭代中，如果一个地面格子周围的地面邻居数量小于此值，它就会变成墙壁。
# 推荐值: 4
@export var survival_threshold: int = 4


# 重写基类的 generate 方法以实现元胞自动机逻辑
func generate(map_data: MapData) -> MapData:
	if not _rng:
		push_error("RNG not set for CellularAutomataPass. Call set_rng() before generating.")
		return map_data

	# 步骤 1: 随机初始化地图
	_randomly_fill_map(map_data)

	# 步骤 2: 多次迭代平滑地图
	for i in range(iterations):
		map_data = _smooth_map(map_data)

	return map_data


# 随机填充地图，根据 ground_chance 决定是墙壁还是地面
func _randomly_fill_map(map_data: MapData) -> void:
	for y in range(map_data.height):
		for x in range(map_data.width):
			# 在地图边缘创建一圈墙壁以包围整个区域
			if x == 0 or x == map_data.width - 1 or y == 0 or y == map_data.height - 1:
				map_data.set_tile(x, y, MapData.TileType.WALL)
			else:
				if _rng.randf() < ground_chance:
					map_data.set_tile(x, y, MapData.TileType.FLOOR)
				else:
					map_data.set_tile(x, y, MapData.TileType.WALL)


# 执行一次平滑迭代
func _smooth_map(map_data: MapData) -> MapData:
	var new_map_data = MapData.new()
	new_map_data.create(Vector2i(map_data.width, map_data.height), MapData.TileType.WALL)

	for y in range(map_data.height):
		for x in range(map_data.width):
			var wall_neighbors = _get_surrounding_wall_count(x, y, map_data)
			var current_tile = map_data.get_tile(x, y)

			if current_tile == MapData.TileType.WALL:
				# 规则1: 如果一个墙壁格子被足够多的地面邻居包围，它就“诞生”为地面
				# (8 - wall_neighbors) 是地面邻居的数量
				if (8 - wall_neighbors) >= birth_threshold:
					new_map_data.set_tile(x, y, MapData.TileType.FLOOR)
				else:
					new_map_data.set_tile(x, y, MapData.TileType.WALL)
			else: # current_tile is FLOOR
				# 规则2: 如果一个地面格子有足够多的地面邻居，它就“幸存”下来
				if (8 - wall_neighbors) >= survival_threshold:
					new_map_data.set_tile(x, y, MapData.TileType.FLOOR)
				else:
					new_map_data.set_tile(x, y, MapData.TileType.WALL)

	return new_map_data


# 获取一个格子周围8个方向的墙壁数量
func _get_surrounding_wall_count(grid_x: int, grid_y: int, map_data: MapData) -> int:
	var wall_count = 0
	for neighbor_y in range(grid_y - 1, grid_y + 2):
		for neighbor_x in range(grid_x - 1, grid_x + 2):
			# 排除格子本身
			if neighbor_x == grid_x and neighbor_y == grid_y:
				continue

			# 如果邻居在边界外，视其为墙壁
			if not map_data._is_in_bounds(neighbor_x, neighbor_y):
				wall_count += 1
			# 如果邻居在边界内且是墙壁
			elif map_data.get_tile(neighbor_x, neighbor_y) == MapData.TileType.WALL:
				wall_count += 1
				
	return wall_count