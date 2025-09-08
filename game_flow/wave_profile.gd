# 波次配置文件
# 这个数据资源用于定义一个完整的、基于时间线的敌人生成波次。
class_name WaveProfileData
extends Resource

# 显式预加载以帮助编译器在无头模式下找到类型
const WaveEvent = preload("res://lib/roguekit/game_flow/wave_event.gd")

# 波次的时间线事件数组。
# WaveManager 将按照时间戳顺序执行这些事件。
@export var timeline_events: Array[WaveEvent] = []