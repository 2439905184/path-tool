import system/io
import os

proc init_command*() = 
  createDir("dpkg/alternatives")
  createDir("etc/alternatives")
  writeFile("etc/mode.txt","alternatives")
