# 移动行动
# 封装了实体移动一个单位的逻辑。
class_name MoveAction
extends BaseAction

var direction: Vector2i

func _init(p_entity: Node, p_direction: Vector2i):
	super._init(p_entity)
	self.direction = p_direction
	self.energy_cost = 100 # 假设移动消耗100能量


func execute():
	# 在这里，我们将移动实体。
	# 这需要与地图数据进行交互，以检查目标位置是否可通行。
	# 目前，我们只打印一条消息。
	print(entity.name + " moves in direction " + str(direction))
	
	# 一个简单的移动实现：
	# var target_pos = entity.global_position + direction * TILE_SIZE
	# if get_world().is_walkable(target_pos):
	#   entity.global_position = target_pos