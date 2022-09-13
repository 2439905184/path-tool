import strformat
import json
import Utils

proc list_command*(p_options:seq[string],mode:string) = 
  if len(p_options) > 1:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  var jsonFile = to_absolute(fmt"dpkg/path/{name}.json")
  var confFile = to_absolute(fmt"dpkg/alternatives/{name}.txt")
  if mode == "alternatives":
    for value in lines(confFile):
      echo value
  if mode == "path":
    var myJsonNode = parseFile(jsonFile)
    for value in myJsonNode["path"]:
      echo value
