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
  let pvTable: Hashtable

  var position = CTPosition()
  var isQuit = false
  
  init(commandSet: CommandSet, evaluator: Evaluator, pvTable: Hashtable) {
    self.commandSet = commandSet
    self.evaluator = evaluator
    self.pvTable = pvTable
  }
  
}

