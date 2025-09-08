# 移动行动
# 封装了实体移动一个单位的逻辑。
class_name MoveAction
extends BaseAction


var direction: Vector2i

func _init(p_entity: Node, p_direction: Vector2i, p_game_manager: Node):
	super._init(p_entity, p_game_manager)
	self.direction = p_direction
	self.energy_cost = 100 # 假设移动消耗100能量

func execute():
	var tile_size = game_manager.tile_size
	if tile_size == Vector2.ZERO:
		push_error("tile_size in GameManager is not set or zero.")
		return
	
	# 1. 坐标计算：将像素坐标转换为网格坐标
	# 假设实体的位置锚点在其中心，或者与网格对齐。使用 round 来处理浮点数不精确问题。
	var current_grid_pos = game_manager.get_grid_position(entity)
	var target_grid_pos = current_grid_pos + direction

	# 2. 碰撞检测（地形）
	if game_manager.current_map_data:
		var target_tile_type = game_manager.current_map_data.get_tile(target_grid_pos.x, target_grid_pos.y)
		if target_tile_type != MapData.TileType.FLOOR:
			print(entity.name + " move blocked by wall at " + str(target_grid_pos))
			return # 撞墙，行动失败，不移动

	# 3. 碰撞检测（其他实体）
	var entity_at_target = game_manager.get_entity_at(target_grid_pos)
	if entity_at_target:
		# print(entity.name + " move blocked by entity " + entity_at_target.name)
		# 移动被阻挡。P7.2中，PlayerInputComponent将利用这一点将移动转换为攻击。
		# AI的MoveAction在这里会失败，防止AI穿过其他实体。
		return

	# 4. 执行移动
	print(entity.name + " moves to " + str(target_grid_pos))
	entity.global_position = Vector2(target_grid_pos) * tile_size.x # 假设 tile_size.x == tile_size.y
	
	# 5. 更新实体位置注册表
	game_manager.update_entity_position(entity, current_grid_pos, target_grid_pos)