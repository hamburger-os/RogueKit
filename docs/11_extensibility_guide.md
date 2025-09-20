[&#8617; 返回总览](../README.md)

---

## 11. 扩展性指南

一个成功的库不仅要功能强大，还必须易于扩展。本章为库的使用者提供清晰的扩展指南。

### 11.1. 定义扩展点

**RogueKit** 的设计从一开始就考虑了扩展性。以下是主要的扩展点：
* **自定义生成算法**: 创建一个新的GDScript脚本并继承自`GenerationPass` `Resource`，实现自己的`generate(map_data)`方法，即可将其作为一个新的生成通道在`MapGenerationProfile`中使用。
* **自定义技能/物品效果**: 继承自`EffectData` `Resource`，实现`execute(context: EffectContext)`方法，即可创建全新的、可被`AbilityData`或`ConsumableData`引用的效果。
* **自定义物品类型**: 继承自`BaseItemData`或其子类，以添加新的物品类别和特定属性。
* **自定义AI行为**: 继承自`BehaviorNode`，创建新的叶节点（Action）或复合节点，即可在`AIBehaviorProfile`中组装更复杂的AI逻辑。

### 11.2. API 约定

库将明确区分公共API和内部实现。通常，以单个下划线`_`开头的方法和变量应被视为私有，不应被外部代码直接依赖，因为它们可能在未来的更新中发生变化。所有暴露给编辑器的`@export`变量和公共信号都是稳定API的一部分。