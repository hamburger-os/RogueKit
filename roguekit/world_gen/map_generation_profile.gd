# 地图生成配置文件
# 这个资源定义了生成一个关卡所需的所有步骤和参数。
# MapGenerator 将按照此文件中定义的顺序，依次执行一系列“生成通道”。
class_name MapGenerationProfile
extends Resource

# 定义生成流程的 GenerationPass 数组
# 开发者可以在编辑器中将不同的生成通道资源拖拽到这里。
@export var generation_passes: Array[GenerationPass] = []