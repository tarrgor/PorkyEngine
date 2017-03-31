//
//  CommandInterpreter.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 27.03.17.
//
//

import Foundation

class CommandInterpreter {
  
  var prompt = ">"
  let commandSet: CommandSet
  let context: CommandContext = CommandContext()
  
  init(commandSet: CommandSet) {
    self.commandSet = commandSet
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
    return Command(action: cmd, args: [])
  }
  
  private func displayPrompt() {
    print("\(self.prompt) ", terminator: "")
  }
  
}
