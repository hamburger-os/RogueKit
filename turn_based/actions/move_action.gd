# 移动行动
# 封装了实体移动一个单位的逻辑。
class_name MoveAction
extends BaseAction


var direction: Vector2i

func _init(p_direction: Vector2i):
	self.direction = p_direction
	self.energy_cost = 100 # 假设移动消耗100能量

func execute(owner: Node):
	# 通过 owner 获取 GameManager
	var game_manager = owner.get_node("/root/GameManager")
	if not game_manager:
		push_error("MoveAction could not find GameManager.")
		return

	var tile_size = game_manager.tile_size
	if tile_size == Vector2.ZERO:
		push_error("tile_size in GameManager is not set or zero.")
		return
	
	# 1. 坐标计算：将像素坐标转换为网格坐标
	var current_grid_pos = game_manager.get_grid_position(owner)
	var target_grid_pos = current_grid_pos + direction

	# 2. 碰撞检测（地形）
	if game_manager.current_map_data:
		var target_tile_type = game_manager.current_map_data.get_tile(target_grid_pos.x, target_grid_pos.y)
		if target_tile_type != MapData.TileType.FLOOR:
			print(owner.name + " move blocked by wall at " + str(target_grid_pos))
			return # 撞墙，行动失败，不移动

	# 3. 碰撞检测（其他实体）
	var entity_at_target = game_manager.get_entity_at(target_grid_pos)
	if entity_at_target:
		# 移动被阻挡
		return

	# 4. 执行移动
	print(owner.name + " moves to " + str(target_grid_pos))
	owner.global_position = Vector2(target_grid_pos) * tile_size.x # 假设 tile_size.x == tile_size.y
	
	# 5. 更新实体位置注册表
	game_manager.update_entity_position(owner, current_grid_pos, target_grid_pos)