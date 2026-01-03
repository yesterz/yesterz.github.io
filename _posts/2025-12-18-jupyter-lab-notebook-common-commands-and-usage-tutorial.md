---
title: Jupyter Lab/Notebook 常用命令与使用教程
date: 2025-12-18 10:00:00 +0800
author: CAFEBABY
categories: [Data Science]
tags: [Python, Jupyter, Data Science]
pin: false
math: true
mermaid: false
---

# Jupyter Lab / Notebook 使用教程

Jupyter Lab 和 Jupyter Notebook 是数据科学家、研究人员和 Python 开发者常用的交互式开发环境，支持在浏览器中编写和运行代码、可视化数据、撰写文档等。本文介绍其基本使用方法与常用命令，帮助你快速上手。

---

## 一、安装 Jupyter

如果你尚未安装 Jupyter，可以通过 `pip` 或 `conda` 安装：

```bash
# 使用 pip 安装
pip install jupyterlab

# 或使用 conda 安装（推荐，尤其如果你使用 Anaconda）
conda install -c conda-forge jupyterlab
```

> ✅ 安装后，`jupyter notebook` 和 `jupyter lab` 命令均可使用。

---

## 二、启动 Jupyter Lab / Notebook

### 1. 默认启动
在终端（Windows PowerShell / CMD / macOS/Linux 终端）中运行：

```bash
jupyter lab
# 或
jupyter notebook
```

这将启动服务并在默认浏览器中打开界面，默认工作目录为执行命令时所在的路径。

### 2. 指定工作目录（推荐）

你可以通过 `--notebook-dir` 参数指定 Jupyter 打开的根目录：

```bash
jupyter lab --notebook-dir=G:\workspace2026
```

> 🔹 路径支持 Windows（如 `G:\workspace2026`）或 Unix 风格（如 `/home/user/notebooks`）。
> 🔹 该路径将成为 Jupyter 文件浏览器的根目录，无法访问其上级目录（出于安全考虑）。

### 3. 指定端口（避免端口冲突）

默认端口是 `8888`，如果被占用，可指定其他端口：

```bash
jumpyter lab --port=8890
```

---

## 三、常用启动选项汇总

| 选项                  | 说明                                         |
| --------------------- | -------------------------------------------- |
| `--notebook-dir=PATH` | 设置 Jupyter 的根工作目录                    |
| `--port=PORT`         | 指定服务端口（默认 8888）                    |
| `--no-browser`        | 启动但不自动打开浏览器（适合远程服务器）     |
| `--ip=0.0.0.0`        | 允许外部访问（配合 `--no-browser` 用于远程） |
| `--allow-root`        | 允许 root 用户运行（Linux 服务器常用）       |

> 💡 示例：远程服务器启动（允许局域网访问）
> ```bash
> jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
> ```

---

## 四、Jupyter Notebook 与 Jupyter Lab 的区别

| 特性       | Jupyter Notebook | Jupyter Lab                    |
| ---------- | ---------------- | ------------------------------ |
| 界面       | 单一笔记本视图   | 多标签、可拖拽的 IDE 风格      |
| 文件浏览器 | 简单列表         | 集成文件管理、终端、文本编辑器 |
| 扩展支持   | 有限             | 丰富插件生态                   |
| 推荐使用   | 快速原型、教学   | 日常开发、项目管理             |

> ✅ **建议新手从 Jupyter Lab 开始**，功能更现代、体验更好。

---

## 五、快捷键（Jupyter Lab）

在 notebook 单元格中：

- `Shift + Enter`：运行当前单元格并跳到下一个
- `Ctrl + Enter`：运行当前单元格，不跳转
- `Esc`：进入命令模式
- `A`（命令模式下）：在上方插入新单元格
- `B`：在下方插入新单元格
- `D, D`（按两次 D）：删除当前单元格
- `M`：将单元格转为 Markdown
- `Y`：转为代码单元格

---

## 六、关闭 Jupyter

- 在终端按 `Ctrl + C` 两次
- 或直接关闭终端（不推荐，可能残留进程）

---

## 七、常见问题

### Q1: 启动后无法访问 `localhost:8888`？

- 检查是否被防火墙/杀毒软件拦截
- 尝试 `127.0.0.1:8888`
- 查看终端输出的 token 或密码（首次启动需输入）

### Q2: 如何生成配置文件？

```bash
jupyter lab --generate-config
```

配置文件路径通常为：`~/.jupyter/jupyter_lab_config.py`

### Q3: 如何设置默认工作目录？

编辑配置文件，添加：

```python
c.ServerApp.root_dir = 'G:/workspace2026'
```

> 注意：Windows 路径使用正斜杠 `/` 或双反斜杠 `\\`

---

## 八、结语

Jupyter 是 Python 数据科学工作流的核心工具之一。掌握其基本命令和配置方式，能极大提升开发效率。建议将常用项目路径设为默认目录，配合版本控制（如 Git）管理 notebook 文件。

> 🌟 提示：`.ipynb` 文件本质是 JSON，可被版本控制系统追踪，但建议配合 `nbstripout` 清理输出以减少冲突。
