# 全局事件总线 (Autoload Singleton)
# 用于处理跨模块的、低耦合的通信。
extends Node

# 实体死亡时发出，参数为死亡的实体节点
signal entity_died(entity: Node)