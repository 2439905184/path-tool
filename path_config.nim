import os
import system/io
import std/json
import std/strutils
import std/private/win_setenv
import std/osproc
import Utils

var params = commandLineParams()

proc config_path(name:string) = 
  var a = readFile("dpkg/path/hello.json")
  var myJsonNode = parseJson(a)
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
  var exit = execCmd("setx hello " & windows_path)
  echo "新的环境变量已创建！"
  echo "退出码：" & $exit

if params[0] == "mode":
  var mode = params[1]
  writeFile("etc/mode.txt",mode)
if params[0] == "config":
  var name = params[1]
  var mode = readFile("etc/mode.txt")
  if mode == "alternatives":
    discard
  if mode == "path":
    config_path(name)

