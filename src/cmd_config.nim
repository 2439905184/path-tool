import os
import system/io
import std/json
import std/strutils
import std/strformat
import osproc
import Utils

proc config_path*(p_options:seq[string]) = 
  if len(p_options) > 1:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  var myJsonFile = absolutePath(fmt"dpkg/path/{name}.json",root=getEnv("PathTool"))
  var myJsonNode:JsonNode = parseFile(myJsonFile)
  var all_path:JsonNode = myJsonNode["path"]
  var current_select = myJsonNode["current"]
  echo "--- you are change a command ---"
  echo "Selection  Path"
  var selections:seq[string] = @[]
  var index = 0
  # 打印状态表
  for line in all_path:
    selections.add(line.getStr())
    var show = fmt"{index}  name  {line.getStr()}"
    echo show
    index += 1
  echo ""
  echo "--- please enter a int to change the default command ---"
  var param = stdin.readLine()
  var select_index = parseInt(param)
  var select:string = selections[select_index]
  echo fmt"你选择了: {select_index} {select}"
  var windows_path = myToWindowsPath(select)
  # 小问题，json文件的current key的值未修改 不过不影响环境变量的切换
  current_select = newJString(select)
  var truePath = to_absolute(fmt"dpkg/path/{name}")
  writeFile(fmt"{truePath}.json",$myJsonNode)
  discard execCmd(fmt"setx {name} {windows_path}")
  
  echo fmt"此命令的绝对路径已更改!"

proc config_symlink*(p_options:seq[string]) = 
  if len(p_options) > 1:
    echo "错误，参数过多！"
  var name = p_options[0]
  var configPath = to_absolute(fmt"dpkg/alternatives/{name}.txt")
  var symlinkPath = to_absolute(fmt"etc/alternatives/{name}.exe")
  echo "--- you are change a command ---"
  echo "Selection  Path"
  var selections:seq[string] = @[]
  var index = 0
  for line in lines(configPath):
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
  removeFile(symlinkPath)
  var srcPath = select
  #var destPath = symlinkPath
  createSymlink(srcPath, symlinkPath)
  echo fmt"新的软链接已创建！{symlinkPath}"