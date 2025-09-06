# BSP 树生成通道
# 使用二叉空间分割 (BSP) 算法来创建由房间和走廊构成的地牢。
class_name BSPTreePass
extends GenerationPass

# 最小房间尺寸，小于此尺寸的区域将不会被进一步分割。
@export var min_room_size: int = 8
# 房间尺寸比例，用于确定房间在分割区域内的大小。
@export var min_room_factor: float = 0.8

var _rng = RandomNumberGenerator.new()


class BSPLeaf:
	var x: int
	var y: int
	var width: int
	var height: int
	var room: Rect2i

	func _init(p_x, p_y, p_width, p_height):
		x = p_x
		y = p_y
		width = p_width
		height = p_height


func generate(map_data: MapData) -> MapData:
	var leaves = []
	var root = BSPLeaf.new(0, 0, map_data.width, map_data.height)
	leaves.append(root)

	var did_split = true
	while did_split:
		did_split = false
		for leaf in leaves:
			if _split_leaf(leaf, leaves):
				did_split = true
				break
	
	_create_rooms(leaves)
	_connect_rooms(map_data, leaves)

	return map_data


func _split_leaf(leaf: BSPLeaf, leaves: Array) -> bool:
	if leaf.width <= min_room_size and leaf.height <= min_room_size:
		return false

	var split_horizontally = _rng.randi_range(0, 1) == 0
	if leaf.width > leaf.height and float(leaf.width) / leaf.height >= 1.25:
		split_horizontally = false
	elif leaf.height > leaf.width and float(leaf.height) / leaf.width >= 1.25:
		split_horizontally = true

	var max_size = (split_horizontally and leaf.height or leaf.width) - min_room_size
	if max_size <= min_room_size:
		return false

	var split = _rng.randi_range(min_room_size, max_size)
	
	leaves.erase(leaf)
	if split_horizontally:
		var leaf_a = BSPLeaf.new(leaf.x, leaf.y, leaf.width, split)
		var leaf_b = BSPLeaf.new(leaf.x, leaf.y + split, leaf.width, leaf.height - split)
		leaves.append(leaf_a)
		leaves.append(leaf_b)
	else:
		var leaf_a = BSPLeaf.new(leaf.x, leaf.y, split, leaf.height)
		var leaf_b = BSPLeaf.new(leaf.x + split, leaf.y, leaf.width - split, leaf.height)
		leaves.append(leaf_a)
		leaves.append(leaf_b)
		
	return true


func _create_rooms(leaves: Array):
	for leaf in leaves:
		var room_width = _rng.randi_range(int(leaf.width * min_room_factor), leaf.width - 2)
		var room_height = _rng.randi_range(int(leaf.height * min_room_factor), leaf.height - 2)
		var room_x = leaf.x + _rng.randi_range(1, leaf.width - room_width - 1)
		var room_y = leaf.y + _rng.randi_range(1, leaf.height - room_height - 1)
		leaf.room = Rect2i(room_x, room_y, room_width, room_height)


func _connect_rooms(map_data: MapData, leaves: Array):
	# First, carve out the rooms
	for leaf in leaves:
		for y in range(leaf.room.position.y, leaf.room.end.y):
			for x in range(leaf.room.position.x, leaf.room.end.x):
				map_data.set_tile(x, y, MapData.TileType.FLOOR)

	# This is a simplified connection logic. A more robust solution would
	# traverse the BSP tree to connect sibling rooms.
	for i in range(len(leaves) - 1):
		var room_a = leaves[i].room
		var room_b = leaves[i+1].room
		var center_a = room_a.get_center()
		var center_b = room_b.get_center()
		_create_tunnel(map_data, int(center_a.x), int(center_a.y), int(center_b.x), int(center_b.y))


func _create_tunnel(map_data: MapData, x1: int, y1: int, x2: int, y2: int):
	var current_x = x1
	var current_y = y1

	while current_x != x2 or current_y != y2:
		if _rng.randi_range(0, 1) == 0 and current_x != x2:
			current_x += 1 if x2 > current_x else -1
		elif current_y != y2:
			current_y += 1 if y2 > current_y else -1
		
		map_data.set_tile(current_x, current_y, MapData.TileType.FLOOR)
