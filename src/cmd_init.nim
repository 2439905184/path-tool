#import system/io
import os
import strformat
import osproc

proc get_path(relative:string):string = 
  return absolutePath(relative,root=getAppDir())

proc init_command*() = 
  let selfPath = getAppDir()
  createDir(get_path("dpkg/alternatives"))
  createDir(get_path("dpkg/path"))
  createDir(get_path("etc/alternatives"))
  writeFile(get_path("etc/mode.txt"),"alternatives")

  var alternativePath = get_path(absolutePath("etc/alternatives"))
  discard execCmd(fmt"setx PathToolAlternative {alternativePath}")
  discard execCmd(fmt"setx PathTool {selfPath}")
  echo "初始化完成"
  echo fmt"PathToolAlternative路径: {alternativePath}"
  echo fmt"PathTool路径: {selfPath}"

