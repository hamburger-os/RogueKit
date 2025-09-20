[&#8617; 返回总览](../README.md)

---

## 4. 物品、库存与掉落子系统

本节设计物品的完整生命周期，从其数据定义、作为战利品生成，到被实体管理和使用的全过程。

### 4.1. 定义物品：`ItemData`资源层级

与实体和能力一样，物品的定义也将采用数据驱动的方式。相比于使用JSON文件，直接使用Godot的`Resource`系统能提供更好的编辑器集成和类型安全。我们将为物品数据建立一个基于继承的`Resource`层级结构：

* **`BaseItemData.gd` (extends `Resource`)**: 所有物品的基类，包含通用数据，如`id`、`name`、`description`、`icon`（图标）、`max_stack_size`（最大堆叠数量）等。
* **`EquipmentData.gd` (extends `BaseItemData`)**: 装备类物品的基类。额外添加`equip_slot`（装备槽位）和一个`StatModifier`数组，这些修改器将在物品被装备时应用到角色身上。
* **`WeaponData.gd` (extends `EquipmentData`)**: 武器的特定数据类。增加伤害属性（如`damage_value`、`damage_type`），并可能引用一个`AbilityData`资源来定义其攻击行为。
* **`ConsumableData.gd` (extends `BaseItemData`)**: 消耗品的基类。包含一个`EffectData`资源数组，当物品被使用时，会创建一个`EffectContext`并依次执行这些效果。

### 4.2. `InventoryComponent`：管理物品集合

库存系统的核心逻辑在于管理一个物品槽位的集合，并处理物品的添加、移除、堆叠和拆分等操作。一些成熟的库存插件（如GLoot）还提供了额外的约束功能，如网格大小限制或负重限制。

**RogueKit** 将提供一个`InventoryComponent.gd`节点作为标准组件。它内部将维护一个数组或字典来表示库存槽位。为了遵循享元模式并节省内存，槽位中存储的将不是`ItemData`资源的完整副本，而是一个轻量级的`InventoryItem` `Object`。这个`InventoryItem`对象将包含一个对`ItemData`资源的引用以及当前的堆叠数量`quantity`。

`InventoryComponent`将提供一套清晰的API供外部调用，例如：
* `add_item(item_data: BaseItemData, quantity: int) -> bool`: 尝试向库存中添加指定数量的物品。
* `remove_item(slot_index: int, quantity: int) -> bool`: 从指定槽位移除指定数量的物品。
* `get_item(slot_index: int) -> InventoryItem`: 获取指定槽位的信息。

### 4.3. 掉落生成管线：`LootTable`资源

战利品掉落是Roguelike游戏奖励循环的核心。我们将设计一个基于`Resource`的、支持权重掉落的系统。

* **`LootTable.gd` (extends `Resource`)**: 定义一个掉落表。其核心是一个`LootEntry`对象的数组。
* **`LootEntry`**: 这是一个内联类或独立的`Object`，用于定义掉落表中的单项。它将包含：
    * 一个对`BaseItemData`资源的引用。
    * 一个`weight`（权重）值，用于决定其在掉落池中的相对概率。
    * 一个数量范围（`min_quantity`, `max_quantity`）。
* `LootTable`资源将提供一个核心方法`roll_loot() -> Array[InventoryItem]`。该方法会根据所有`LootEntry`的权重进行一次或多次加权随机抽选，并返回一个包含生成的`InventoryItem`对象的数组。

**集成**：为了将掉落系统与实体连接起来，可以创建一个`LootDropComponent.gd`组件。这个组件可以附加到敌人或其他可掉落物品的实体上。它将持有一个对`LootTable`资源的引用，并在监听到其所有者的`health_depleted`信号时，调用`roll_loot()`方法来生成战利品，并将其在游戏世界中实例化。