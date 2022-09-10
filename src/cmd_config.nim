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
  var myJsonFile = readFile(fmt"dpkg/path/{name}.json")
  var myJsonNode = parseJson(myJsonFile)
  var all_path = myJsonNode["path"]
  var current_select = myJsonNode["current-select"].getStr()
  echo "--- you are change a command ---"
  echo "Selection  Path"
  var selections:seq[string] = @[]
  var index = 0

  for line in all_path:
    selections.add(line.getStr())
    var show = $index & "  " & name & "  " & line.getStr()
    echo show
    index += 1
  echo ""
  echo "--- please enter a int to change the default command ---"
  var param = stdin.readLine()
  var select_index = parseInt(param)
  var select:string = selections[select_index]
  echo select_index
  echo "你选择了: " & select
  var windows_path = myToWindowsPath(select)
  var exit = execCmd(fmt"setx {name} {windows_path}")
  echo fmt"新的环境变量已创建！ 请手动配置path环境变量，在里面加入 %{name}%"
  echo "退出码：" & $exit

proc config_symlink*(p_options:seq[string]) = 
  if len(p_options) > 1:
    echo "错误，参数过多！"
  var name = p_options[0]
  var full_name = name & ".exe"
  var configPath = fmt"dpkg/alternatives/{name}.txt"
  var symlinkPath = "/etc/alternatives"
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
  removeFile("etc/alternatives/" & full_name)
  var srcPath = select
  var destPath = absolutePath(full_name,root=getCurrentDir() & symlinkPath)
  createSymlink(srcPath, destPath)
  echo "新的软链接已创建！"