//
//  CommandDescriptors.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 03.04.17.
//
//

import Foundation
import ChessToolkit

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
}
