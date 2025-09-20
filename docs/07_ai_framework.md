[&#8617; 返回总览](../README.md)

---

## 7. AI行为框架

一个强大的Roguelike库需要提供一个可扩展的AI框架，让开发者能够轻松创建多样化的敌人行为，而不仅仅是简单的“追逐并攻击”。

### 7.1. AI设计模式：行为树

虽然有限状态机（FSM）对于简单的AI是可行的，但随着行为复杂度的增加，它很容易变得难以管理。因此，**RogueKit**将采用**行为树（Behavior Trees）** 作为其核心AI设计模式。行为树以其模块化和可组合性而著称，非常适合构建复杂的AI逻辑。

我们将定义一套基础的行为树节点类，全部继承自`BehaviorNode`：
* **组合节点 (Composite Nodes)**: 如 `Sequence`（顺序执行，一败则败）和 `Selector`（顺序执行，一成则成）。
* **装饰节点 (Decorator Nodes)**: 如 `Inverter`（反转子节点的结果）和 `Repeater`（重复执行子节点）。
* **叶节点 (Leaf Nodes / Action Nodes)**: 这是执行具体游戏逻辑的地方，例如 `Action_FindPlayer`、`Action_MoveToTarget`、`Action_Attack`。这些节点最终会生成一个`Action`对象并提交给`TurnManager`。

### 7.2. 数据驱动的AI配置：`AIBehaviorProfile`

为了贯彻数据驱动的设计哲学，AI的逻辑本身也应该是可配置的资源。

* **`AIBehaviorProfile.gd` (extends `Resource`)**: 这个资源将作为行为树的蓝图。在Godot编辑器中，开发者可以通过将不同的`BehaviorNode`资源拖拽并组合成一个树状结构，来定义一个敌人的完整AI逻辑。
* **`AIComponent.gd` (extends `Node`)**: 这个组件被附加到实体上，它持有一个对`AIBehaviorProfile`资源的引用。当轮到该实体行动时，`AIComponent`会执行（tick）其行为树，行为树将评估当前的游戏状态（通过访问兄弟组件如`StatsComponent`）并最终返回一个`Action`对象。

这种设计将AI行为的创建从复杂的编码任务转变为可视化的、在编辑器中进行的组装工作，极大地提高了开发效率和灵活性。