//
//  CommandContext.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 30.03.17.
//
//

import Foundation
import ChessToolkit

class CommandContext {
  
  let commandSet: CommandSet
  
  var position = CTPosition()
  var isQuit = false
  
  init(commandSet: CommandSet) {
    self.commandSet = commandSet
  }
  
}

