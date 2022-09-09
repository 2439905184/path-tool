# path-tool
使用多种语言实现的windows系统下的自动化环境变量配置工具（仿linux的update-alternatives ）

## 使用方法
1. 先把etc/alternatives目录添加到系统的环境变量path（需要是绝对路径）
2. main.exe install "命令名称" "绝对路径"
3. main.exe config "命令名称" //此时它会问你要切换到哪个版本，输入序号就可以了
4. 在系统的其他文件夹打开cmd命令行，然后输入xxx.exe 或者xxx 快速调用etc/alternatives目录下的软链接的exe程序