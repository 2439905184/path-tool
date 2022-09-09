# 此文件是模仿linux下的update-alternatives命令，但是无法用于配置java，适用于无第三方依赖dll的静态链接exe
import os
import system/io
import std/strutils
const symlinkPath = "/etc/alternatives"
const configPath = "dpkg/alternatives/"

# 为名称为xxx的exe文件创建软链接，第二个参数是exe文件的完整绝对路径，如D:\test\test.exe
proc install(name:string, path:string) = 
  var full_name = name & ".exe"
  var srcPath = path
  var destPath = absolutePath(full_name,root=getCurrentDir() & symlinkPath)
  echo "计算的src绝对路径: " & srcPath
  echo "计算的dest绝对路径: " & destPath
  var f:File = open(configPath & name, fmAppend)
  f.write(path & "\n")
  f.close()
  # 第一个参数是源文件，第二个参数是软链接为文件要放置的路径
  createSymlink(srcPath, destPath) # 函数原型 createSymlink(src,dest) #把src的文件软链接到dest文件

proc init() = 
  createDir("dpkg/alternatives")
  createDir("etc/alternatives")

proc config(name:string) = 
  var full_name = name & ".exe"
  echo "--- you are change a command ---"
  echo "Selection  Path"
  var selections:seq[string] = @[]
  var index = 0
  for line in lines(configPath & name):
    selections.add(line)
    var show = $index & "  " & name & "  " & line
    echo show
    index += 1
  echo ""
  echo "--- please enter a int to change the default command ---"
  var param = stdin.readLine()
  var select_index = parseInt(param)
  var select = selections[select_index]
  echo "你选择了：" & select
  removeFile("etc/alternatives/" & full_name)
  var srcPath = select
  var destPath = absolutePath(full_name,root=getCurrentDir() & symlinkPath)
  createSymlink(srcPath, destPath)
  echo "新的软链接已创建！"

var params = commandLineParams()
if params[0] == "help" or len(params) == 0:
  echo "用法: path-tool 选项 参数1 参数2..."
  echo ""
  echo "命令："
  echo "init 初始化并创建配置文件夹"
  echo "install 名称 绝对路径"
  #echo "remove 名称"
  echo "config 名称      列出<名称>的可选项，让用户选择使用哪个"
else:
  if params[0] == "init":
    init()
  if params[0] == "install":
    install(params[1],params[2])
  if params[0] == "config":
    config(params[1])




# 完整的可用创建过程
proc create() = 
  var src = r"D:\Desktop\path-tool\test\hello2.exe"
  var dest = absolutePath("hello2.exe",root=getCurrentDir() & "/etc/alternatives")
  echo src
  echo dest
  createSymlink(src,dest)

