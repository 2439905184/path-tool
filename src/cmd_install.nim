import os
import system/io
import strformat
import strutils
import std/sequtils
import std/json
import Utils
import osproc

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
    #echo "--初始--"
    #echo "旧行: " , old_lines
    #echo "新行: " , new_lines
    add_new_line_when_old_file_do_not_include_new_value(fmt"dpkg/alternatives/{name}.txt",srcPath)

# 为名称为xxx的路径添加到json文件中 并创建名为xxx的环境变量
proc install_path*(p_options:seq[string]) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var name:string = p_options[0]
  var windows_path:string = p_options[1]

  var unix_path = myToLinuxPath(windows_path)
  var jsonFile = fmt"dpkg/path/{name}.json"
  var old_paths:JsonNode 
  var path_json:JsonNode = newJString(unix_path)

  if fileExists(jsonFile):
    var myJsonNode = parseFile(jsonFile)
    old_paths = myJsonNode["path"]
    var oldPath:seq[JsonNode] = old_paths.getElems()

    for value in oldPath:
      if not(path_json in old_paths):
        
        old_paths.add(path_json)
    writeFile(fmt"dpkg/path/{name}.json",$myJsonNode)
  else:
    var myJson = %*{"env":"","path":[]}
    myJson["env"] = newJString(name)
    myJson["path"].add(newJString(unix_path))
    writeFile(fmt"dpkg/path/{name}.json",$myJson)
    discard execCmd(fmt"setx {name} {windows_path}")
    echo fmt"环境变量: {name} 已添加，请手动在用户环境变量的path加入%{name}%"