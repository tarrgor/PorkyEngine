import PorkyEngine

print("Porky Engine V1.0")

let commandSet = StandardCommandSet()
let context = CommandContext(commandSet: commandSet, evaluator: SimpleEvaluator())
let commandInterpreter = CommandInterpreter(context: context)
commandInterpreter.run()

