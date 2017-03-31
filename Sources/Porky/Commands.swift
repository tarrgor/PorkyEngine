//
//  Commands.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 27.03.17.
//
//

import Foundation

typealias CommandExecutor = (CommandContext, inout Command) throws -> ()

enum ParseError: Error {
  case invalidCommand(cmd: String)
}

struct Command {
  let action: String
  let args: [String]
}

struct ParsedCommand {
  let action: String
  let args: [String]
  
  let execute: CommandExecutor
}

struct CommandDescriptor {
  let actionName: String
  let numberOfArgs: Int
  let usageInfo: String
  
  let execute: CommandExecutor
}

protocol CommandSet {
  var actions: [String:CommandDescriptor] { get }
  
  func parse(command: Command) throws -> ParsedCommand
}

struct StandardCommandSet: CommandSet {
  let actions: [String:CommandDescriptor] = [
    "quit": CommandDescriptor(actionName: "quit", numberOfArgs: 0, usageInfo: "quit - Exit the Porky Engine") {
      context, command in
      context.isQuit = true
    }
  ]
  
  func parse(command: Command) throws -> ParsedCommand {
    guard let descriptor = actions[command.action] else {
      throw ParseError.invalidCommand(cmd: command.action)
    }
    return ParsedCommand(action: command.action, args: command.args, execute: descriptor.execute)
  }
}
