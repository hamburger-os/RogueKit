[&#8617; 返回总览](../README.md)

---

## 14. 贡献指南与社区规范

为了确保代码质量的一致性和团队协作的效率，所有贡献者均需遵守以下规范。

### 14.1. Git 工作流

* **分支策略**:
    * `master`: 始终保持稳定，对应最新的发行版（Release）。禁止直接推送代码到`master`。
    * `develop`: 开发中的主分支，包含下一版本的所有新功能。所有功能分支都应从此分支创建。
    * `feature/<feature-name>`: 用于开发新功能的分支。完成后合并回`develop`。
    * `fix/<issue-number>`: 用于修复Bug的分支。完成后合并回`develop`，必要时挑选（Cherry-pick）到`master`以发布热修复。
* **提交规范 (Commit Message)**: 强烈建议遵循**Conventional Commits**规范（例如 `feat: add health component`, `fix: correct loot table calculation`）。这有助于自动化生成更新日志。

### 14.2. Pull Request (PR) 流程

1.  **关联Issue**: 每个PR都应关联一个已创建的Issue（问题追踪）。
2.  **代码审查**: 至少需要一名核心开发者审查并批准后方可合并。
3.  **自测通过**: 提交者必须确保所有相关的自动化测试（单元测试和集成测试）都能通过。PR描述中应说明如何手动测试该功能。
4.  **保持小巧**: 避免巨型PR。尽可能将大的功能拆分为多个小的、独立的PR提交。

### 14.3. 社区行为准则

本项目采用标准的贡献者行为准则（Contributor Covenant）。所有参与讨论和贡献的成员都应保持尊重、友好和建设性的态度。

### 14.4. 文档的可维护性

随着 **RogueKit** 的功能不断丰富，这份单一的 `README.md` 设计文档可能会变得异常庞大，从而影响其可读性和可维护性。我们预见到，在项目进入 v1.2 或更成熟的阶段后，将本文档拆分为一个结构化的 `docs/` 目录是必要的。

该目录可以包含多个 Markdown 文件，例如：
* `docs/01_architecture_principles.md`
* `docs/02_world_generation.md`
* `docs/03_entity_component_system.md`
* ...以此类推

这种结构化的文档将更易于导航、更新和社区贡献。在当前阶段，我们仍将所有设计集中于此 `README.md` 以方便快速查阅和迭代，但所有贡献者都应意识到这一未来的演进方向。