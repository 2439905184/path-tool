import system/io
import os
import strformat
import osproc

proc init_command*() = 
  var selfPath = getAppDir()
  createDir("dpkg/alternatives")
  createDir("etc/alternatives")
  writeFile("etc/mode.txt","alternatives")
  var alternativePath = absolutePath("etc/alternatives",root=selfPath)
  discard execCmd(fmt"setx PathToolAlternative {alternativePath}")
  discard execCmd(fmt"setx PathTool {selfPath}")
  echo "初始化完成"
  echo fmt"PathToolAlternative路径: {alternativePath}"
  echo fmt"PathTool路径: {selfPath}"