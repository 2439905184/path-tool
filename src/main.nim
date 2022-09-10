# 此文件是模仿linux下的update-alternatives命令，但是无法用于配置java，适用于无第三方依赖dll的静态链接exe
import os
import system/io
import std/strutils
import cmd_init
import Alternatives
import path_config
import Utils
import version

const symlinkPath = "/etc/alternatives"
const configPath* = "dpkg/alternatives/"
const workModeAlter* = "alternatives"
const workModePath* = "path"

if fileExists("etc/mode.txt"):
  var currentWorkMode = getWorkMode()

var params = commandLineParams()
if params[0] == "help" or len(params) == 0:
  help()
else:
  if params[0] == "init":
    init()

  if params[0] == "mode":
    var mode = params[1]
    writeFile("etc/mode.txt",mode)

  if params[0] == "install":
    var mode = getWorkMode()
    if mode == workModeAlter:
      install(params[1],params[2])
    if mode == workModePath:
      install(params[1])

  if params[0] == "config":
    var mode = getWorkMode()
    if mode == workModeAlter:
      config_symlink(params[1],params[2])
    if mode == workModePath:
      config_path(name)
  
  if params[0] == "remove":
    remove(params[1],params[1])
  if params[0] == "remove_all":
    remove_all(params[1],currentWorkMode)
  
  if params[0] == "version":
    echo version