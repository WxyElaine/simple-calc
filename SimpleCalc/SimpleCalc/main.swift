//  Class: INFO 449
//  Name: Xinyi Wang
//  Project: SimpleCalc
//
//  Created by Xinyi Wang on 10/9/17.
//  Copyright © 2017 Xinyi Wang. All rights reserved.

import Foundation

/* Takes a string and a pattern in the regular expression format as parameters.
     Checks if the given string matches the regular expression. Returns true if match, false otherwise. */
func checkIfValid(checkString: String, pattern: String) -> Bool {
    let range = checkString.startIndex..<checkString.endIndex
    let correctRange = checkString.range(of: pattern, options: .regularExpression)
    if correctRange == range {
        return true
    } else {
        return false
    }
}

/* Takes an array of type double, a string representing the operator, and a boolean representing if the user
     enters integer values or not (true for integer values, and false for double values).
     Calculate the result using the given operator and returns the result as string. */
func simpleCalcAndPrint(numbers: Array<Double>, calcOperator: String, intType: Bool) -> String {
    var calcResult = 0.0
    var mode = 0
    switch calcOperator {
    case "+":
        calcResult = numbers[0] + numbers[1]
    case "-":
        calcResult = numbers[0] - numbers[1]
    case "*":
        calcResult = numbers[0] * numbers[1]
    case "/":
        calcResult = numbers[0] / numbers[1]
    case "%":
        mode = Int(numbers[0]) - (Int(numbers[0]) / Int(numbers[1])) * Int(numbers[1])
    default:
        return "Your passed an invalid operator, enter again."
    }
    if calcOperator == "%" {
        return "\(mode)"
    } else if intType == true {
        return "\(Int(calcResult))"
    } else {
        return "\(calcResult)"
    }
}

// Main part of the program starts here!

print("This is a simple calculator, please enter an expression separated by returns. ")
print("Double enter retrun to exit. ")

var numbers: [Double] = []
var multiOperand: [String] = []
var index = 0
var input = readLine(strippingNewline: true)!
var calcOperator = ""
var varInt = true

// Keeps executing the program until the user hits enter twice to exit.
while input != "" {
    input = input.trimmingCharacters(in: .whitespacesAndNewlines)    
    if index == 1 {
        calcOperator = input
    } else {
        input = input.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        multiOperand = input.components(separatedBy: " ")
        if multiOperand.count == 1 {
            let checkResult = checkIfValid(checkString: multiOperand[0], pattern: "^[+-]?[0-9]+(.[0-9]+)?$")
            if checkResult == true {
                // Check if it's an Int or Double
                varInt = varInt && checkIfValid(checkString: multiOperand[0], pattern: "^[+-]?[0-9]+$")
                numbers.append(Double.init(multiOperand[0])!)
            } else {
                index = -2
                print("Result: Invalid input, enter again")
            }
        } else {
            var checkResult = true
            for i in 0...multiOperand.count - 2 {
                checkResult = checkResult && checkIfValid(checkString: multiOperand[i], pattern: "^[+-]?[0-9]+(.[0-9]+)?$")
            }
            if checkResult == true {
                index += 2
            } else {
                index = -2
                print("=> Invalid input, enter again")
            }
        }
    }
    index += 1
    // Calculates and prints the result.
    if index == 3 {
        if (numbers.count == 2) {
            let printContent = simpleCalcAndPrint(numbers: numbers, calcOperator: calcOperator, intType: varInt)
            print("Result:", terminator: " ")
            print(printContent)
        } else {
            print("=>", terminator: " ")
            switch multiOperand[multiOperand.count - 1] {
            case "count":
                print(multiOperand.count - 1)
            case "avg":
                var sum = 0.0
                for i in 0...multiOperand.count - 2 {
                    // Check if it's an Int or Double
                    varInt = varInt && checkIfValid(checkString: multiOperand[i], pattern: "^[+-]?[0-9]+$")
                    sum += Double.init(multiOperand[i])!
                }
                if varInt == true {
                    print(Int(sum) / (multiOperand.count - 1))
                } else {
                    print(sum / Double((multiOperand.count - 1)))
                }
            case "fact":
                // Check if it's an Int
                varInt = varInt && checkIfValid(checkString: multiOperand[0], pattern: "^[+]?[0-9]+$")
                if multiOperand.count == 2 && varInt == true {
                    var factorial = 1
                    for i in 1...Int.init(multiOperand[0])! {
                        factorial *= i
                    }
                    print(factorial)
                } else if multiOperand.count != 2 && varInt != true {
                    print("You've passed more than one number, and at least one of your numbers is not a positive integer, enter again.")
                } else if multiOperand.count != 2 {
                    print("You've passed more than one number, enter again.")
                } else {
                    print("You didn't pass a positive integer, enter again.")
                }
            default:
                print("You didn't pass a valid multi-operand command, enter again.")
            }
        }
    }
    // Clear all previous data
    if index == 3 || index == -1 {
        index = 0
        numbers.removeAll()
        multiOperand.removeAll()
        varInt = true
    }
    input = readLine(strippingNewline: true)!
}
