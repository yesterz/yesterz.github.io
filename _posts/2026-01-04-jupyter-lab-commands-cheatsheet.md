```yaml
---
title: Jupyter Lab 常用命令速查指南
date: 2026-01-07 09:30:00 +0800
categories: [Programming, Python]
tags: [jupyter, jupyter-lab, python, data-science, terminal]
---
```

# Jupyter Lab 常用命令速查指南

在使用 Python 进行数据分析、机器学习或日常编程时，**Jupyter Lab** 是一个非常受欢迎的交互式开发环境。通过 **Anaconda Prompt** 启动和管理 Jupyter 服务是 Windows 用户的常见做法。本文整理了与 Jupyter（包括 Jupyter Lab 和经典 Notebook）相关的常用终端命令，帮助你更高效地使用这一工具。

---

## 🔹 启动命令

最基础的启动方式：

```bash
jupyter lab                 # 启动 Jupyter Lab
jupyter notebook            # 启动经典 Jupyter Notebook
```

执行后，系统会自动在默认浏览器中打开 Web 界面。

---

## 🔹 指定工作目录

若希望在特定项目目录下启动，可使用 `--notebook-dir` 参数：

```bash
jupyter lab --notebook-dir="G:/workspace2026"
jupyter notebook --notebook-dir="G:/workspace2026"
```

> 注意：路径建议使用正斜杠 `/` 或双反斜杠 `\\`，避免转义问题。

---

## 🔹 生成配置文件

如需自定义端口、密码、默认目录等高级设置，可生成配置文件：

```bash
jupyter lab --generate-config      # 生成 Lab 配置
jupyter notebook --generate-config # 生成 Notebook 配置
```

配置文件默认保存在：  
`C:\Users\<你的用户名>\.jupyter\jupyter_lab_config.py`

---

## 🔹 查看正在运行的服务

有时你可能不确定 Jupyter 是否已在后台运行，可以使用：

```bash
jupyter server list        # 查看所有运行中的 Jupyter 服务（含 token 和路径）
jupyter notebook list      # 兼容旧版，列出 notebook 服务
```

---

## 🔹 停止服务

在启动 Jupyter 的终端窗口中，按 **`Ctrl + C` 两次**即可安全关闭服务。

---

## 🔹 其他实用命令

### 不自动打开浏览器（适合远程开发）
```bash
jupyter lab --no-browser
```

### 指定端口（默认为 8888）
```bash
jupyter lab --port=8889
```

### 查看 Jupyter 的路径与配置位置
```bash
jupyter --paths
```

### 管理 Jupyter Lab 扩展（需已安装 Node.js）
```bash
jupyter labextension list              # 列出已安装扩展
jupyter labextension install @foo/bar  # 安装新扩展（示例）
```

---

## ✅ 小贴士

- 建议在项目根目录下启动 Jupyter，便于文件管理和路径引用。
- 若遇到端口被占用，可换用 `--port=8890` 等其他端口。
- 配置文件中可设置密码、默认目录、禁用 token 等，提升使用体验（生产环境注意安全）。

---

掌握这些命令后，你就能更灵活地控制 Jupyter 环境，提升本地开发效率。欢迎将本指南作为速查备忘！

---

**文件命名**：`2026-01-07-jupyter-lab-commands-cheatsheet.md`