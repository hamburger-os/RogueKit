# 波次时间线事件
# 定义在波次进行到特定时间点时发生的操作。
class_name WaveEvent
extends Resource

# 事件类型枚举
enum Action {
	START_SPAWNING, # 开始生成一种新的敌人
	STOP_SPAWNING,  # 停止生成一种敌人
	MODIFY_SPAWN,   # 修改一个正在进行的生成规则（例如，提高生成率）
	SPAWN_GROUP,    # 立即生成一组特定的敌人
	SET_BOSS_FLAG,  # 触发Boss战状态
}

@export_group("Event Trigger")
# 游戏内时间戳（秒），当游戏时间达到此值时触发此事件。
@export var timestamp: float = 0.0

@export_group("Event Action")
# 此事件要执行的操作。
@export var action: Action = Action.START_SPAWNING

# 根据不同的 'action'，以下字段可能被使用：
@export var enemy_key: String = "" # 用于 START/STOP/MODIFY，标识敌人类型
@export var spawn_rate: float = 1.0 # 每秒生成数量
@export var max_alive: int = 10 # 场上该类型敌人的最大数量
@export var spawn_group: Array[EntityData] # 用于 SPAWN_GROUP