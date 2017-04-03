print("Porky Engine V1.0")

let commandSet = StandardCommandSet()
let context = CommandContext(commandSet: commandSet)
let commandInterpreter = CommandInterpreter(context: context)
commandInterpreter.run()

