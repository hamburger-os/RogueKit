# 生成通道基类
# 这是策略模式的基础，定义了所有具体地图生成算法的接口。
# 任何继承此类的资源都可以被添加到 MapGenerationProfile 中作为一个生成阶段。
class_name GenerationPass
extends Resource


var _rng: RandomNumberGenerator


# 设置此通道将使用的随机数生成器实例。
# 由 MapGenerator 在执行前调用。
func set_rng(p_rng: RandomNumberGenerator) -> void:
	self._rng = p_rng


# 核心方法，所有子类都必须重写此方法以实现其独特的生成逻辑。
# 它接收一个 MapData 对象，对其进行修改，然后返回修改后的 MapData。
# @param map_data [MapData]: 当前的地图数据对象。
# @return [MapData]: 修改后的地图数据对象。
func generate(map_data: MapData) -> MapData:
	# 这个基类方法只是一个占位符，并警告用户需要实现它。
	push_error("GenerationPass.generate() is not implemented. Please override it in the child class.")
	return map_data