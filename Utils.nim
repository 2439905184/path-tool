import std/strutils

proc myToWindowsPath*(path: string): string = 
  return path.replace("/", "\\")