//
//  CommandContext.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 30.03.17.
//
//

import Foundation
import PorkyEngine
import ChessToolkit

class CommandContext {
  
  let commandSet: CommandSet
  let evaluator: Evaluator

  var position = CTPosition()
  var isQuit = false
  
  init(commandSet: CommandSet, evaluator: Evaluator) {
    self.commandSet = commandSet
    self.evaluator = evaluator
  }
  
}

