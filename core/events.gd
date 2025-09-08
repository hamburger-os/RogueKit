# 全局事件总线 (Autoload Singleton)
# 用于处理跨模块的、低耦合的通信。
extends Node

# 实体死亡时发出，参数为死亡的实体节点
signal entity_died(entity: Node)

# 实体受到伤害时发出
# 参数: 实体, 伤害量, 伤害来源 (可能为 null)
signal entity_took_damage(entity: Node, amount: int, source: Node)

# 玩家完成一个回合后发出
signal player_took_turn

# 玩家捡起物品时发出
# 参数: 玩家实体, 物品数据, 数量
signal player_picked_up_item(player: Node, item_data: BaseItemData, quantity: int)

# 玩家升级时发出
# 参数: 玩家实体, 新等级
signal player_leveled_up(player: Node, new_level: int)