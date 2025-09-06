# AI 行为配置
# 这个资源作为行为树的蓝图。它持有一个对根节点的引用，
# 从而定义了一个敌人的完整AI逻辑。
class_name AIBehaviorProfile
extends Resource

# 行为树的根节点
@export var root_node: BehaviorNode