import system/io

proc remove_all*(p_options:seq[string],workMode:string) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  var path = p_options[1]
  
  if workMode == "alternatives":
    removeFile(fmt"etc/alternatives/{name}.exe")
    removeFile(fmt"etc/alternatives/{name}")
  
  if workMode == "path":
    removeFile(fmt"dpkg/path/{name}.json")
    delEnv(name)