import os
import system/io
import strformat
import strutils
import std/sequtils
import Utils

# 为名称为xxx的exe文件创建软链接，第二个参数是exe文件的完整绝对路径，如D:\test\test.exe
proc install_symlink*(p_options:seq[string]) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  elif len(p_options) == 1:
    echo "错误，参数过少！"
    return
  var symlinkPath = "/etc/alternatives"
  var configPath = "dpkg/alternatives/"
  var name = p_options[0]
  var path = p_options[1]
  var full_name = name & ".exe"
  var srcPath = path
  var destPath = absolutePath(full_name,root=getCurrentDir() & symlinkPath)
  
  if not symlinkExists(fmt"etc/alternatives/{fullname}"):
    echo "计算的src绝对路径: " & srcPath
    echo "计算的dest绝对路径: " & destPath
    createSymlink(srcPath, destPath) # 函数原型 createSymlink(src,dest) #把src的文件软链接到dest文件 第一个参数是源文件的绝对路径，第二个参数是软链接文件的绝对路径
    var f:File = open(configPath & name & ".txt", fmAppend)
    f.write(path & "\n")
    f.close()
    echo fmt"软链接文件已添加: {destPath}" 
  else:
    echo fmt"软链接文件已存在，新路径: {srcPath} 已添加到组: {name}"
    var old_lines:seq[string] = to_seq(lines(fmt"dpkg/alternatives/{name}.txt"))
    var new_lines:seq[string] = old_lines
    echo "--初始--"
    echo "旧行: " , old_lines
    echo "新行: " , new_lines
    add_new_line_when_old_file_do_not_include_new_value(fmt"dpkg/alternatives/{name}.txt",srcPath)
# 为名称为xxx的路径添加到json文件中 并创建名为xxx的环境变量
proc install_path*(p_options:seq[string]) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  #writeFile(fmt"dpkg/path/{name}.json",json)