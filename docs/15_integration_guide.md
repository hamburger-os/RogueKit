[&#8617; 返回总览](../README.md)

---

## 15. 库的集成与初步使用

本设计文档描绘了 **RogueKit** ——一个模块化、数据驱动且高度可扩展的Roguelike库的架构蓝图。其核心优势在于：通过**组合**实现模块化，通过**数据驱动**实现灵活性，通过**清晰的架构模式**实现可维护性。

对于希望使用 **RogueKit** 的开发者，其典型的工作流程（即“内容创作管线”）将如下所示：
1.  **定义内容**: 在Godot编辑器中，为游戏创建一系列继承自 **RogueKit** 基类的`Resource`文件，用以定义物品（`ItemData`）、实体（`EntityData`）、能力（`AbilityData`）等。
2.  **组装实体**: 创建新的实体场景（如`Player.tscn`），并将 **RogueKit** 提供的组件场景（`HealthComponent.tscn`, `InventoryComponent.tscn`等）作为子节点添加进去，然后将上一步创建的`EntityData`资源赋给实体根节点的导出变量。
3.  **设计关卡**: 创建`MapGenerationProfile`和`SpawnProfile`资源，通过在编辑器中拖拽和配置`GenerationPass`资源来设计关卡的生成算法和怪物分布。
4.  **启动游戏**: 使用`GameManager`单例来启动一次新的游戏运行，它将自动协调`MapGenerator`和`Spawner`等系统来构建和填充游戏世界。

这种工作流程将开发的核心从编码转移到了内容配置上，充分体现了 **RogueKit** 的设计哲学，旨在为Roguelike游戏的快速原型设计和迭代开发提供强大的支持。