import system/io

proc remove_all*(p_options:seq[string],workMode:string) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  
  if workMode == "alternatives":
    removeFile(fmt"etc/alternatives/{name}.exe")
    removeFile(fmt"dpkg/alternatives/{name}.txt")
  
  if workMode == "path":
    removeFile(absolutePath(fmt"dpkg/path/{name}.json",getEnv("PathTool")))
    delEnv(name)