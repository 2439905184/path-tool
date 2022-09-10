import std/strutils

proc myToWindowsPath*(path: string): string = 
  return path.replace("/", "\\")

proc getWorkMode*(): string = 
  return readFile("etc/mode.txt")