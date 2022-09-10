import strformat

proc list_command*(p_options:seq[string],mode:string) = 
  if len(p_options) > 1:
    echo "错误，参数过多！"
    return
  var name = p_options[0]
  if mode == "alternatives":
    for value in lines(fmt"dpkg/alternatives/{name}.txt"):
      echo value
  if mode == "path":
    var myJsonNode = parseJson(fmt"dpkg/path/{name}.json")
    for value in myJsonNode["path"]:
      echo value
