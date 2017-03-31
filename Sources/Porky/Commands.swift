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
  case invalidNumberOfArguments(args: Int, needs: Int)
}

protocol Command {
  var action: String { get }
  var args: [String] { get }
}

protocol Executable {
  var execute: CommandExecutor { get }
}

struct InputCommand: Command {
  let action: String
  let args: [String]
}

struct ExecutableCommand: Command, Executable {
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
  
  func parse(command: Command) throws -> Executable
}

extension CommandSet {
  func parse(command: Command) throws -> Executable {
    guard let descriptor = actions[command.action] else {
      throw ParseError.invalidCommand(cmd: command.action)
    }
    if command.args.count != descriptor.numberOfArgs {
      throw ParseError.invalidNumberOfArguments(args: command.args.count, needs: descriptor.numberOfArgs)
    }
    return ExecutableCommand(action: command.action, args: command.args, execute: descriptor.execute)
  }
}

struct StandardCommandSet: CommandSet {
  let actions: [String:CommandDescriptor] = [
    "quit": CommandDescriptor(actionName: "quit", numberOfArgs: 0, usageInfo: "quit - Exit the Porky Engine") {
      context, command in
      context.isQuit = true
    }
  ]
}
