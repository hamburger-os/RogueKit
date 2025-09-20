# 移动行动
# 封装了实体向某个方向移动一个格子的意图。
class_name MoveAction
extends BaseAction

var direction: Vector2i

func _init(p_direction: Vector2i):
	self.direction = p_direction
	# 移动通常消耗一个标准回合的能量
	self.energy_cost = 100


# 执行移动逻辑
# 委托给 owner 的 MovementComponent (如果存在) 或直接修改其位置。
func execute(owner: Node):
	if not is_instance_valid(owner):
		return

	# 理想情况下，应该由 MovementComponent 处理
	# 这里为了简化，我们直接修改 owner 的位置
	var current_grid_pos = GameManager.get_grid_position(owner)
	var target_grid_pos = current_grid_pos + direction
	
	# 检查目标位置是否可通过
	var map_data = GameManager.current_map_data
	if map_data and map_data.get_tile(target_grid_pos.x, target_grid_pos.y) == MapData.TileType.FLOOR:
		# 检查目标位置是否被其他实体占据
		if not GameManager.get_entity_at(target_grid_pos):
			var target_world_pos = Vector2(target_grid_pos) * GameManager.tile_size
			owner.global_position = target_world_pos
			GameManager.update_entity_position(owner, current_grid_pos, target_grid_pos)