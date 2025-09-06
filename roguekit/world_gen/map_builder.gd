# 地图构建器
# 负责读取 MapData 对象中的信息，并根据预设的 TileSet 将其渲染到
# 实际的 TileMap 或 GridMap 节点上。
class_name MapBuilder
extends Node

# 渲染地图
# @param map_data [MapData]: 包含地图布局的抽象数据。
# @param tile_map [TileMap]: 用于渲染地图的目标 TileMap 节点。
# @param wall_tile_id [int]: 墙壁瓦片的图块ID。
# @param floor_tile_id [int]: 地面瓦片的图块ID。
func build_map(map_data: MapData, tile_map: TileMap, wall_tile_id: int, floor_tile_id: int):
	tile_map.clear()
	
	for y in range(map_data.height):
		for x in range(map_data.width):
			var tile_type = map_data.get_tile(x, y)
			var tile_id = wall_tile_id if tile_type == MapData.TileType.WALL else floor_tile_id
			tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(tile_id, 0))