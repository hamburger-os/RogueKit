# 效果数据基类
# 这是所有具体效果（如造成伤害、施加状态）的数据资源的父类。
# 它可以被 AbilityData 或 ConsumableData 引用。
class_name EffectData
extends Resource


# 核心方法，所有子类都必须重写此方法以实现其效果逻辑。
# @param context [EffectContext]: 包含效果执行所需所有信息的上下文对象。
func execute(context: EffectContext):
	push_error("EffectData.execute() is not implemented. Please override it in the child class.")