import std/strformat
import system/io

proc remove*(p_options:seq[string],workMode:string) = 
  if len(p_options) > 2:
    echo "错误，参数过多！"
    return
  var name = p_options[0] 
  var path = p_options[1]
  
  var configPath = "dpkg/alternatives/"
  var configFile:string = configPath & name
  
  if workMode == "alternatives":
    var all_path:seq[string] = @[]
    for value in lines(configFile):
      all_path.add(value)
    
    for key,value in all_path:
      if value == path:
        all_path.delete(key)
    var f:File = open(configPath,fmAppend)
    for value in all_path:
      f.write(value & "\n")
    f.close()
    removeFile(fmt"etc/alternatives/{name}.exe")

  if workMode == "path":
    var jsonFile = fmt"dpkg/path/{name}.json"
    var myJsonNode = parseJson(jsonFile)
    var all_path = myJsonNode["path"]
    for key,value in all_path:
      if value.getStr() == path:
        all_path.delete(key)
    #writeFile(jsonFile,)#myJsonNode)