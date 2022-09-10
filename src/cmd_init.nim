import system/io
import os
import strformat
import osproc

proc init_command*() = 
  createDir("dpkg/alternatives")
  createDir("etc/alternatives")
  writeFile("etc/mode.txt","alternatives")
  var alternativePath = absolutePath("etc/alternatives")
  discard execCmd(fmt"setx PathToolAlternative {alternativePath}")