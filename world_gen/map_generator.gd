# 地图生成器 (协调器)
# 该节点本身不包含任何具体的生成算法逻辑，其核心职责是作为一个协调器。
# 它接收一个 MapGenerationProfile 资源作为输入，并按顺序执行其中定义的所有“生成通道”。
class_name MapGenerator
extends Node

# 生成一个新地图
# @param width [int]: 地图宽度
# @param height [int]: 地图高度
# @param profile [MapGenerationProfile]: 定义生成流程的配置文件
# @param seed_value [int]: 用于保证生成过程确定性的种子
# @return [MapData]: 生成的抽象地图数据对象
func generate_map(width: int, height: int, profile: MapGenerationProfile, seed_value: int) -> MapData:
	var map_data = MapData.new()
	map_data.create(width, height, MapData.TileType.WALL)
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_value
	
	if not profile or not profile.generation_passes:
		push_warning("MapGenerationProfile is empty. Returning a solid wall map.")
		return map_data
		
	for gen_pass in profile.generation_passes:
		# 将RNG实例传递给每个通道，以确保整个过程使用同一个种子
		if "_rng" in gen_pass:
			gen_pass._rng = rng
		map_data = gen_pass.generate(map_data)
		
	return map_data