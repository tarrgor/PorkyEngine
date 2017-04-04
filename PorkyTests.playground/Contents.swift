//: Playground - noun: a place where people can play

import ChessToolkit
import PorkyEngine


func moveFromString(_ move: String) -> CTMove? {
  guard move.characters.count == 4 else { return nil }
  
  let fromIdx = move.index(move.startIndex, offsetBy: 2)
  let from = move.substring(to: fromIdx)
  let to = move.substring(from: fromIdx)
  print("\(from) - \(to)")
  return nil
}


let str = "e2e4"
moveFromString(str)


