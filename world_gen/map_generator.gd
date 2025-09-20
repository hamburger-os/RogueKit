# 地图生成器 (协调器)
# 该节点本身不包含任何具体的生成算法逻辑，其核心职责是作为一个协调器。
# 它接收一个 MapGenerationProfile 资源作为输入，并按顺序执行其中定义的所有“生成通道”。
class_name MapGenerator
extends Node

# 生成一个新地图
# @param profile [MapGenerationProfile]: 定义生成流程和尺寸的配置文件
# @param seed_value [int]: 用于保证生成过程确定性的种子
# @return [MapData]: 生成的抽象地图数据对象
func generate_map(profile: MapGenerationProfile, seed_value: int) -> MapData:
	if not profile:
		push_error("MapGenerationProfile is null. Cannot generate map.")
		return null
		
	var map_data = MapData.new()
	map_data.create(profile.map_size, MapData.TileType.WALL)
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seed_value
	
	if not profile.generation_passes:
		push_warning("MapGenerationProfile has no generation passes. Returning a solid wall map.")
		return map_data
		
	for gen_pass in profile.generation_passes:
		if not gen_pass:
			push_warning("A null GenerationPass was found in the profile. Skipping.")
			continue
		
		# 使用标准化的方法传递RNG实例
		gen_pass.set_rng(rng)
		map_data = gen_pass.generate(map_data)
		
	return map_data