import os

proc mode_command*(p_options:seq[string]) = 
  if len(p_options) > 1:
    echo "错误，参数过多！"
    return
  elif p_options[0] != "path" and p_options[0] != "alternatives":
    echo "错误，不支持的参数值！"
    echo "仅支持 path 或 alternatives参数"
    return
  var mode = p_options[0]
  
  var truePath = absolutePath("etc/mode.txt",root=getEnv("PathTool"))
  #echo truePath
  writeFile(truePath,mode)