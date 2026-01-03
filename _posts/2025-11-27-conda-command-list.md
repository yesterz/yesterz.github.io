常用 conda 命令概述
环境管理
conda create：创建新环境
conda activate：激活环境
conda deactivate：退出当前环境
conda env list / conda info --envs：列出所有环境
conda remove：删除环境
包管理
conda install：安装包
conda update：更新包
conda remove：卸载包
conda list：查看已安装的包
环境导出与克隆
conda env export：导出环境配置
conda env create：通过环境配置文件创建环境
conda list --explicit：导出所有包的精确安装列表
conda clone：克隆现有环境
搜索和查看
conda search：搜索包
conda info：显示环境和配置的详细信息
其他命令
conda clean：清理缓存
conda config：配置 conda 设置
conda package：构建自定义包


环境管理
1. 创建新环境 (conda create)
用于创建一个新的虚拟环境。

bash
conda create --name myenv 
--name：指定环境的名称，可以替换 myenv 为你希望的环境名。
--channel / -c：指定源渠道（如 conda-forge）。
--python：指定环境的 Python 版本。
示例：
bash
conda create --name myenv python=3.8 
2. 激活环境 (conda activate)
激活一个已有的虚拟环境。

bash
conda activate myenv 
3. 退出环境 (conda deactivate)
退出当前激活的虚拟环境。

bash
conda deactivate
4. 列出环境 (conda env list 或 conda info --envs)
列出所有已创建的环境，并显示当前激活的环境。

bash
conda env list
# 或者
conda info --envs
5. 删除环境 (conda remove)
删除虚拟环境及其中的所有内容。

bash
conda remove --name myenv --all
--all：删除整个环境。
包管理
1. 安装包 (conda install)
用于安装包和其依赖。

bash
conda install numpy
默认安装最新版本的包。
可以指定版本号进行安装，如 conda install numpy=1.18.5。
可以指定从特定渠道安装，如 conda install -c conda-forge numpy。
示例：
bash
conda install pandas=1.2.3
2. 更新包 (conda update)
更新指定包到最新版本。

bash
conda update numpy
3. 卸载包 (conda remove)
卸载已安装的包。

bash
conda remove numpy
4. 查看已安装的包 (conda list)
查看当前环境下已安装的包及其版本。

bash
conda list
conda list numpy：查看某个特定包的版本。
conda list --explicit：列出所有安装包的精确版本列表，适合环境的移植。
环境导出与克隆
1. 导出环境配置 (conda env export)
将当前环境的配置导出为一个 .yml 文件。可以方便地共享环境配置，或者以后重建相同的环境。

bash
conda env export > environment.yml
2. 通过 .yml 文件创建环境 (conda env create)
通过 environment.yml 文件来创建一个新环境。

bash
conda env create -f environment.yml
-f：指定 .yml 文件路径。
你可以指定环境名称：conda env create -f environment.yml --name newenv。
3. 克隆环境 (conda create --clone)
克隆一个现有的环境，创建一个相同的环境。

bash
conda create --name newenv --clone oldenv
oldenv 是原始环境的名称。
newenv 是你希望创建的新环境。
搜索和查看
1. 搜索包 (conda search)
用于搜索可用的包。

bash
conda search numpy
可以指定包的版本：conda search numpy=1.18.5。
可以指定渠道：conda search numpy -c conda-forge。
2. 查看 conda 配置信息 (conda info)
显示关于 conda 安装、环境、渠道等的详细信息。

bash
conda info
 
清理和配置
1. 清理缓存 (conda clean)
清理下载的缓存文件，释放磁盘空间。

bash
conda clean --all
--all：删除所有缓存。
--packages：只删除安装包的缓存。
--tarballs：删除 .tar.bz2 包缓存。
2. 配置 conda 设置 (conda config)
管理 conda 配置文件（如 .condarc）。

bash
conda config --add channels conda-forge
conda config --remove channels defaults
--add：将 conda-forge 加入配置渠道。
--remove：删除指定渠道。
构建自定义包
1. 构建包 (conda build)
从源代码构建一个新的包，适合创建和共享自定义软件包。

bash
conda build .
需要在当前目录中有一个 meta.yaml 文件，描述包的构建信息。
总结
常用命令回顾：
环境管理：
创建环境：conda create --name myenv
激活环境：conda activate myenv
查看环境：conda env list
删除环境：conda remove --name myenv --all
包管理：
安装包：conda install numpy
更新包：conda update numpy
卸载包：conda remove numpy
查看包：conda list
环境导出与克隆：
导出环境：conda env export > environment.yml
创建环境：conda env create -f environment.yml
克隆环境：conda create --name newenv --clone oldenv
搜索与查看：
搜索包：conda search numpy
查看配置信息：conda info
