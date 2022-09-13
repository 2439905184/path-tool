cd src
nim c -d:release -d:strip --opt:size path_tool.nim 
copy path_tool.exe ..\
del path_tool.exe
cd ..