//
//  CommandDescriptors.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 03.04.17.
//
//

import Foundation
import ChessToolkit
import PorkyEngine

class Descriptors {

  static let quitCmd: CommandDescriptor = {
    return CommandDescriptor(actionName: "quit", numberOfArgs: 0, usageInfo: "quit - Exit the Porky Command Line Utility") {
      context, command in
      context.isQuit = true
    }
  }()
  
  static let positionCmd: CommandDescriptor = {
    return CommandDescriptor(actionName: "pos", numberOfArgs: 0, usageInfo: "pos - Print current position") {
      context, command in
      let position: CTPosition = context.position
      print(position)
    }
  }()
  
  static let helpCmd: CommandDescriptor = {
    return CommandDescriptor(actionName: "help", numberOfArgs: 0, usageInfo: "help - Show this help info") {
      context, command in
      let actions = context.commandSet.actions.values
      actions.forEach { action in
        print(action.usageInfo)
      }
    }
  }()
  
  static let searchCmd: CommandDescriptor = {
    return CommandDescriptor(actionName: "search", numberOfArgs: 0, usageInfo: "search - Search the best move possible in the current position") {
      context, command in
      let searcher = Searcher(position: context.position)
      let start = Date().timeIntervalSince1970
      let _ = searcher.search()
      let end = Date().timeIntervalSince1970
      print("Needed \(end - start)")
    }
  }()
  
  static let moveCmd: CommandDescriptor = {
    return CommandDescriptor(actionName: "move", numberOfArgs: 1, usageInfo: "move <moveString> - Execute the specified move e.g. move e2e4") {
      context, command in
      if let move = moveFromString(context.position, command.args[0]) {
        if !context.position.makeMove(from: move.from, to: move.to) {
          print("Could not execute move.")
        } else {
          print("Move executed.\n")
          print(context.position)
        }
      } else {
        print("Error parsing the move argument: \(command.args[0])")
      }
    }
  }()
  
  static let evalCmd: CommandDescriptor = {
    return CommandDescriptor(actionName: "eval", numberOfArgs: 0,
                             usageInfo: "eval - Show evaluation of the current position") {
      context, command in
      print("Current evaluation: \(context.position.evaluate())")
    }
  }()
}

extension Descriptors {
  
  fileprivate static func moveFromString(_ position: CTPosition, _ move: String) -> CTMove? {
    guard move.characters.count == 4 else { return nil }
    
    let fromIdx = move.index(move.startIndex, offsetBy: 2)
    
    guard let from = CTSquare.fromString(move.substring(to: fromIdx)) else { return nil }
    guard let to = CTSquare.fromString(move.substring(from: fromIdx)) else { return nil }
    
    return CTMoveBuilder.build(position, from: from, to: to)
  }
  
}

