import osproc
import Utils
import strformat

proc remove_all*(p_options:seq[string],workMode:string) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  
  if workMode == "alternatives":
    removeFile(to_absolute(fmt"etc/alternatives/{name}.exe"))
    removeFile(to_absolute(fmt"dpkg/alternatives/{name}.txt"))
  
  if workMode == "path":
    removeFile(to_absolute(fmt"dpkg/path/{name}.json"))
    discard execCmd(fmt"setx {name} empty")
    echo fmt"user Env: {name} has been set to empty string!"