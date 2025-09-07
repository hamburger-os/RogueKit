# 地图构建器
# 负责读取 MapData 对象中的信息，并根据预设的 TileSet 将其渲染到
# 实际的 TileMap 或 GridMap 节点上。
class_name MapBuilder
extends Node

@export_group("Tile Configuration")
# TileSet 中墙壁瓦片的图块 ID (Atlas Coords X)
@export var wall_tile_id: int = 0
# TileSet 中地板瓦片的图块 ID (Atlas Coords X)
@export var floor_tile_id: int = 1
# TileSet source ID
@export var tile_source_id: int = 0

# 渲染地图
# @param map_data [MapData]: 包含地图布局的抽象数据。
# @param tile_map [TileMap]: 用于渲染地图的目标 TileMap 节点。
func build_map(map_data: MapData, tile_map: TileMap):
	tile_map.clear()
	
	for y in range(map_data.height):
		for x in range(map_data.width):
			var tile_type = map_data.get_tile(x, y)
			var tile_atlas_coord_x = wall_tile_id if tile_type == MapData.TileType.WALL else floor_tile_id
			tile_map.set_cell(0, Vector2i(x, y), tile_source_id, Vector2i(tile_atlas_coord_x, 0))