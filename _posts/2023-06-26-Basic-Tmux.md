---
title: "Tmux优秀的终端复用工具"
categories:
  - Tools
tags: [Tools]
toc: true
---

## 改掉默认终端为 Tmux

```sh
# use Tmux only if current terminal program is xterm-256color
if [ "$TERM" = 'xterm-256color' ]; then
  tmux has -t risk &> /dev/null
  if [ $? != 0 ]; then
    tmux new -s risk
  elif [ -z $TMUX ]; then
    tmux attach -t risk
  fi
fi
```

## tmux使用学习文档

1. Tmux 使用手册 [https://louiszhai.github.io/2017/09/30/tmux/](https://louiszhai.github.io/2017/09/30/tmux/)
2. 基础教程 [https://www.ruanyifeng.com/blog/2019/10/tmux.html](https://www.ruanyifeng.com/blog/2019/10/tmux.html)
3. tmux之道？Tao of Tmux [https://tao-of-tmux.readthedocs.io/zh_CN/latest/](https://tao-of-tmux.readthedocs.io/zh_CN/latest/)
4. Tmux Cheat Sheet & Quick Reference [https://tmuxcheatsheet.com/](https://tmuxcheatsheet.com/)

## 基本使用流程


    # step 1: 新建会话
    tmux new -s <my_session>
    
    # step 2: 在 Tmux 窗口运行所需的程序
    
    # step 3: 按下快捷键将会话分离
    Ctrl+b d
    
    # step 4: 下次使用时，重新连接到会话
    tmux attach-session -t <my_session>


## 快捷键速查表格


| Ctrl+b       | 激活控制台；此时以下按键生效                                 |
| ------------ | ------------------------------------------------------------ |
| **系统操作** | **系统操作**                                                 |
| ?            | 列出所有快捷键；按q返回                                      |
| d            | 脱离当前会话；这样可以暂时返回Shell界面，输入tmux attach能够重新进入之前的会话 |
| D            | 选择要脱离的会话；在同时开启了多个会话时使用                 |
| Ctrl+z       | 挂起当前会话                                                 |
| r            | 强制重绘未脱离的会话                                         |
| s            | 选择并切换会话；在同时开启了多个会话时使用                   |
| :            | 进入命令行模式；此时可以输入支持的命令，例如kill-server可以关闭服务器 |
| [            | 进入复制模式；此时的操作与vi/emacs相同，按q/Esc退出          |
| ~            | 列出提示信息缓存；其中包含了之前tmux返回的各种提示信息       |
| **窗口操作** | **窗口操作**                                                 |
| c            | 创建新窗口                                                   |
| &            | 关闭当前窗口                                                 |
| 数字键       | 切换至指定窗口                                               |
| p            | 切换至上一窗口                                               |
| n            | 切换至下一窗口                                               |
| l            | 在前后两个窗口间互相切换                                     |
| w            | 通过窗口列表切换窗口                                         |
| ,            | 重命名当前窗口；这样便于识别                                 |
| .            | 修改当前窗口编号；相当于窗口重新排序                         |
| f            | 在所有窗口中查找指定文本                                     |
| **面板操作** | **面板操作**                                                 |
| ”            | 将当前面板平分为上下两块                                     |
| %            | 将当前面板平分为左右两块                                     |
| x            | 关闭当前面板                                                 |
| !            | 将当前面板置于新窗口；即新建一个窗口，其中仅包含当前面板     |
| Ctrl+方向键  | 以1个单元格为单位移动边缘以调整当前面板大小                  |
| Alt+方向键   | 以5个单元格为单位移动边缘以调整当前面板大小                  |
| Space        | 在预置的面板布局中循环切换；依次包括even-horizontal、even-vertical、main-horizontal、main-vertical、tiled |
| q            | 显示面板编号                                                 |
| o            | 在当前窗口中选择下一面板                                     |
| 方向键       | 移动光标以选择面板                                           |
| {            | 向前置换当前面板                                             |
| }            | 向后置换当前面板                                             |
| Alt+o        | 逆时针旋转当前窗口的面板                                     |
| Ctrl+o       | 顺时针旋转当前窗口的面板                                     |

## 常用操作

### 建立新的 tmux 窗口


    # 默认编号命名
    tmux
    
    # 推荐使用自定义窗口名称(窗口外使用)
    tmux new -s <session-name>
    

### 退出当前 tmux 窗口


    # 显式输入(窗口内使用)
    tmux dettach
    
    # 快捷键(linux)(窗口内使用)
    Ctrl+b　d


### 查看所有 tmux 窗口


    # 在窗口外显式输入
    tmux ls
    OR
    tmux list-session
    
    # 在窗口内显式输入
    tmux detach
    
    # 在窗口内快捷键(linux)
    Ctrl+b s


### 接入窗口


    # 使用会话编号(窗口外使用)
    tmux attach -t 0
    OR
    tmux at -t 0
    
    # 使用会话名称(窗口外使用)
    tmux attach -t <session-name>
    OR
    tmux at -t <session-name>


### 杀死、切换、重命名会话


    # 使用会话编号(窗口内外均可)
    tmux kill-session -t 0
    
    # 使用会话名称(窗口内外均可)
    tmux kill-session -t <session-name>
    
    # 在窗口内显式输入
    exit
    # 使用会话编号
    $ tmux switch -t 0
    
    # 使用会话名称
    $ tmux switch -t <session-name>
    # 显式输入(窗口内外均可使用)
    tmux rename-session -t <old-name> <new-name>
    
    # 快捷键(linux)
    Ctrl+b $
    

### 划分窗格


    # 划分上下两个窗格
    tmux split-window　# 显式输入
    Ctrl+b " # 快捷键 
    
    # 划分左右两个窗格
    tmux split-window -h # 显式输入
    Ctrl+b % # 快捷键
    
    # 光标切换到上方窗格
    tmux select-pane -U # 显式输入
    Ctrl+b <up arrow key> # 快捷键
    Ctrl+b ; # 快捷键
    
    # 光标切换到下方窗格
    tmux select-pane -D # 显式输入
    Ctrl+b <down arrow key> # 快捷键
    Ctrl+b o # 快捷键
    
    # 光标切换到左边窗格
    tmux select-pane -L # 显式输入
    Ctrl+b <left arrow key> # 快捷键
    
    # 光标切换到右边窗格
    tmux select-pane -R # 显式输入
    Ctrl+b <right arrow key> # 快捷键
    
    # 当前窗格上移
    tmux swap-pane -U # 显式输入
    Ctrl+b { # 快捷键
    
    # 当前窗格下移
    tmux swap-pane -D # 显式输入
    Ctrl+b } # 快捷键
    
    # 关闭当前窗格
    Ctrl+b x # 快捷键



## 常用配置文件

配置文件位于 ~/.tmux.conf

```
    set -g prefix ^b
    set -g prefix2 F9
    bind ^b send-prefix
    
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    bind C-l select-window -l
    setw -g mode-keys vi
    setw -g utf8 on
    bind -t vi-copy v begin-selection
    bind -t vi-copy y copy-selection
    
    
    # List of plugins
    set -g @plugin 'tmux-plugins/tpm'
    set -g @plugin 'tmux-plugins/tmux-sensible'
    
    # Other examples:
    # set -g @plugin 'github_username/plugin_name'
    # set -g @plugin 'git@github.com/user/plugin'
    # set -g @plugin 'git@bitbucket.com/user/plugin'
    
    # Initialize TMUX plugin manager (keep this line at the very bottom of
    # tmux.conf)
    run '~/.tmux/plugins/tpm/tpm'
    
    
    set -s escape-time 0
    
    
    bind c new-window -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
    bind '"' split-window -c "#{pane_current_path}"
    
    
    run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
    
    
    set-window-option -g utf8 on
    set -g default-terminal "screen-256color"
```