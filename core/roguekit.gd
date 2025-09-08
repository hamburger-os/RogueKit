# RogueKit 全局常量和静态辅助函数
# 这是一个自动加载的单例，用于存放整个库中共享的常量和枚举。
# 它可以避免在代码中使用“魔法字符串”，提高代码的可维护性和可读性。
class_name Roguekit
extends Node

# 核心属性名称
# 使用这些常量来访问 StatsComponent 中的属性，以避免硬编码字符串。
const STATS = {
	"SPEED": "speed",
	"STRENGTH": "strength",
	# ... 可以在这里添加其他核心属性，如 "dexterity", "intelligence" 等
}

# 可以在这里添加其他全局枚举或常量，例如：
# enum DamageType { PHYSICAL, FIRE, ICE }
