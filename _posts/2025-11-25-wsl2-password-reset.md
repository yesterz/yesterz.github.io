<h1> WSL2 密码重置</h1>

在 WSL2 中，如果忘记了 Linux 子系统的用户密码，可以通过以下步骤重置密码。整个过程分为三步：切换默认用户为 *root*、重置密码、再切换回普通用户。

## 1. 切换默认用户为 root

打开 **命令提示符 (cmd)** 或 **PowerShell**，以管理员身份运行。

查看已安装的 Linux 子系统：

```cmd
wsl -l
```

将目标子系统的默认用户切换为 *root*：

```cmd
ubuntu2004 config --default-user root
```

## 2. 重置普通用户密码

启动目标子系统（此时会以 *root* 用户登录）。

使用以下命令重置普通用户的密码（将 *username* 替换为实际用户名）：

```bash
passwd username
```

按提示输入新密码并确认。屏幕上不会显示输入内容，这是正常现象。

## 3. 切换回普通用户

再次打开 **命令提示符 (cmd)** 或 **PowerShell**。

将默认用户切换回普通用户：

```cmd
ubuntu2004 config --default-user username
```

**注意事项**

* 如果子系统名称或版本不明确，可通过`wsl -l`查看。

* 若遇到路径问题，可尝试定位到实际的可执行文件路径，例如：

```cmd
cd "C:\Program Files\WindowsApps\<子系统路径>"
debian config --default-user root
```

重置完成后，确保测试新密码是否有效。

通过以上步骤，即可成功重置 WSL2 的用户密码。