# 元进度数据
# 这个资源封装了所有需要跨运行持久化的数据。
# SaveManager 将负责将这个资源的实例保存到文件系统。
class_name MetaProgressionData
extends Resource

# --- 示例数据 ---

# 玩家拥有的全局货币
@export var global_currency: int = 0

# 已解锁的角色ID列表
@export var unlocked_characters: Array[String] = ["default_warrior"]

# 已购买的永久性升级
# Key: upgrade_id (String), Value: level (int)
@export var permanent_upgrades: Dictionary = {}

# 可以在这里添加更多需要持久化的数据...
# 例如:
# @export var highest_level_reached: int = 0
# @export var total_enemies_defeated: int = 0