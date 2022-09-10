import os
import system/io

# 为名称为xxx的exe文件创建软链接，第二个参数是exe文件的完整绝对路径，如D:\test\test.exe
proc install_symlink*(p_options:seq[string]) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var symlinkPath = "/etc/alternatives"
  var configPath = "dpkg/alternatives/"
  var name = p_options[0]
  var path = p_options[1]
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

# 为名称为xxx的路径添加到json文件中 并创建名为xxx的环境变量
proc install_path*(p_options:seq[string]) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  
  #writeFile(fmt"dpkg/path/{name}.json",json)