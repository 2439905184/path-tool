import system/io
import osproc

proc remove_all*(p_options:seq[string],workMode:string) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  
  if workMode == "alternatives":
    removeFile(absolutePath(fmt"etc/alternatives/{name}.exe", root=getEnv("PathTool")))
    removeFile(absolutePath(fmt"dpkg/alternatives/{name}.txt", root=getEnv("PathTool")))
  
  if workMode == "path":
    removeFile(absolutePath(fmt"dpkg/path/{name}.json",getEnv("PathTool")))
    discard execCmd(fmt"setx {name} empty")
    echo fmt"user Env: {name} has been set to empty string!"