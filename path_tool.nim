import os
import script
import Utils

var full_params:seq[string]
var command_type:string
var args:seq[string]
var currentWorkMode:string = "alternatives"

if fileExists("etc/mode.txt"):
  currentWorkMode = getWorkMode()

try:
  full_params = commandLineParams()
  command_type = full_params[0]
except:
  #help_command()
  discard
finally:
  discard

args = full_params[1..len(full_params)-1]
echo args
#echo args
case command_type:
  of "init":
    init_command()
  of "mode":
    mode_command(args)
  of "install":
    if currentWorkMode == "alternatives":
      install_symlink(args)
    if currentWorkMode == "path":
      install_path(args)
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
    list_command(args,currentWorkMode)
  of "version":
    version_command()
  of "help":
    help_command()
  else:
    echo "不支持的命令"