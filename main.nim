import os
import system/io

const symlinkPath = "/etc/alternatives"
const configPath = "dpkg/alternatives/"

# 为名称为xxx的exe文件创建软链接，第二个参数是exe文件的完整绝对路径，如D:\test\test.exe
proc install(name:string, path:string) = 
  var full_name = name #& ".exe"
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

var params = commandLineParams()
if params[0] == "help" or len(params) == 0:
  echo "用法: path-tool 选项 参数1 参数2..."
  echo ""
  echo "命令："
  echo "install 名称 绝对路径"
  #echo "remove 名称"
  echo "config 名称      列出<名称>的可选项，让用户选择使用哪个"
else:
  if params[0] == "init":
    init()
  if params[0] == "install":
    install(params[1],params[2])

#var src = absolutePath("hello2.exe",root=getCurrentDir() & "/test")
# 完整的可用创建过程
proc create() = 
  var src = r"D:\Desktop\path-tool\test\hello2.exe"
  var dest = absolutePath("hello2.exe",root=getCurrentDir() & "/etc/alternatives")
  echo src
  echo dest
  createSymlink(src,dest)

