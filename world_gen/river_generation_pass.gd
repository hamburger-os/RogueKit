# 河流生成通道
# 使用随机游走算法在地图上生成一条“河流”。
# 这是一个如何扩展自定义地图生成通道的示例。
class_name RiverGenerationPass
extends GenerationPass

# 河流的宽度
@export var river_width: int = 3
# 随机游走的总步数
@export var walk_steps: int = 200

# 重写 generate 方法
func generate(map_data: MapData) -> MapData:
	if not _rng:
		push_error("RNG not set for RiverGenerationPass. Call set_rng() before generating.")
		return map_data

	# 从左侧边缘随机一个点开始
	var start_y = _rng.randi_range(map_data.height / 4, map_data.height * 3 / 4)
	var current_pos = Vector2i(0, start_y)

	for _i in range(walk_steps):
		# 绘制河流
		_carve_river_tile(map_data, current_pos)

		# 随机移动“挖掘者”
		var move_dir = _get_random_direction()
		current_pos += move_dir
		
		# 强制挖掘者向右移动，以确保河流横穿地图
		current_pos.x += 1

		# 检查边界，如果走出边界则停止
		if not map_data._is_in_bounds(current_pos.x, current_pos.y):
			break
			
	return map_data

func _carve_river_tile(map_data: MapData, pos: Vector2i):
	for y in range(pos.y - river_width / 2, pos.y + river_width / 2 + 1):
		for x in range(pos.x - river_width / 2, pos.x + river_width / 2 + 1):
			if map_data._is_in_bounds(x, y):
				map_data.set_tile(x, y, MapData.TileType.FLOOR)

func _get_random_direction() -> Vector2i:
	var rand = _rng.randi_range(0, 3)
	if rand == 0:
		return Vector2i.UP
	elif rand == 1:
		return Vector2i.DOWN
	elif rand == 2:
		return Vector2i.LEFT
	else:
		return Vector2i.RIGHT