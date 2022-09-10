import os
import script
import Utils
import WorkMode

var full_params:seq[string]
var command_type:string
var args:seq[string]
var currentWorkMode:string = "alternatives"

if fileExists("etc/mode.txt"):
  currentWorkMode = getWorkMode()

try:
  full_params = commandLineParams()
  command_type = full_params[0]
except IndexError:
  help_command()
finally:
  discard

args = full_params[1..len(full_params)-1]
if len(args) != 0:
  echo args
case command_type:
  of "init":
    init_command()
  of "mode":
    if len(full_params) == 1:
      echo "当前模式: " & currentWorkMode
    elif len(full_params) > 1:
      mode_command(args)
  of "install":
    if len(args) > 0:
      if currentWorkMode == "alternatives":
        install_symlink(args)
      if currentWorkMode == "path":
        install_path(args)
    elif len(args) == 0:
      echo "错误，参数过少！"
  of "config":
    if currentWorkMode == "alternatives":
      config_symlink(args)
    if currentWorkMode == "path":
      config_path(args)
  of "remove":
    remove(args,currentWorkMode)
  of "remove_all":
    remove_all(args,currentWorkMode)
  of "list":
    if len(args) == 1:
      list_command(args,currentWorkMode)
    else: echo "参数过多或者过少！请检查输入"
  of "version":
    version_command()
  of "help":
    help_command()
  else:
    echo "不支持的命令"