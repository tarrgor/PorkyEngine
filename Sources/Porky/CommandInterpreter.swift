//
//  CommandInterpreter.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 27.03.17.
//
//

import Foundation

class CommandInterpreter {
  
  let context: CommandContext
  
  init(context: CommandContext) {
    self.context = context
  }
  
  func run() {
    while !context.isQuit {
      displayPrompt()
      if var cmd = readCommand() {
        do {
          let parsedCmd = try commandSet.parse(command: cmd)
          try parsedCmd.execute(context, &cmd)
        } catch {
          print(error)
        }
      }
    }
  }
  
  private func readCommand() -> Command? {
    guard let cmd = readLine() else { return nil }
    var parts = cmd.components(separatedBy: " ")
    let action = parts.removeFirst()
    let args = parts
    return InputCommand(action: action, args: args)
  }
  
  private func displayPrompt() {
    print("\(self.context.commandSet.prompt) ", terminator: "")
  }
  
}
