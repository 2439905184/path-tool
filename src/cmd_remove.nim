import std/strformat
import system/io
import std/json

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
    var myJsonNode = parseFile(jsonFile)
    var all_path:seq[JsonNode] = myJsonNode["path"].getElems()
    var new_path:seq[string] = @[]
    #echo "--初始--"
    #echo "all_path: ", all_path
    # 单独创建一个字符串类型的序列 用于操作和序列化
    for value in all_path:
      new_path.add(value.getStr())
    # 处理新路径数组序列
    var index = 0
    for vv in 0..len(new_path):
      if path in new_path:
        new_path.delete(index)
      index += 1
    echo "--修改后--"
    var myNewJson = %* {"selfVar":fmt"{name}","path":new_path}
    echo myNewJson
    writeFile(jsonFile,$myNewJson)