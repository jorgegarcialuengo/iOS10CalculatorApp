//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jorge García-Luengo on 10/7/17.
//  Copyright © 2017 Jorge García-Luengo. All rights reserved.
//

import Foundation

//func changeSign(operand: Double) -> Double {
//    return -operand
//}

//func multiply(op1: Double, op2:Double) -> Double {
//    return op1 * op2
//}

struct CalculatorBrain {
    //clasees have inheritances, structs do not
    //classes live in the heap, and you have pointers to them, structs don't so they are copyed around
    //any method that changes the value of a variable has to be marked muttating

    private var accumulator: Double? // private because it's for internal use only
    
    var resultIsPending = false
    
    private var description: String?
    
    var lastDescription: String?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "∛" : Operation.unaryOperation(cbrt),
        "∜" : Operation.unaryOperation({pow($0,0.25)}),
        "sen" : Operation.unaryOperation(sin),
        "eˣ" : Operation.unaryOperation( {pow(M_E,$0)}),
        "10ˣ" : Operation.unaryOperation({pow(10,$0)}),
        "x²" : Operation.unaryOperation({pow($0,2)}),
        "x³" : Operation.unaryOperation({pow($0,3)}),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),

        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        setDescriptionWith(symbol)
        
        if let operation = operations[symbol] {

            switch  operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let funcion):
                if accumulator != nil{accumulator = funcion(accumulator!)}
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    if resultIsPending != true {resultIsPending = true}
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
            }
        }

        print("result is pending \(resultIsPending)")
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!) //pbo? in pbo only unwrapps it if its not nil
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    mutating func setDescriptionWith(_ symbol: String) {
        var valueToAppend: String?
        //if resultIsPending != true { description = nil}
        var smallAccumulator: String?
        
        if accumulator != nil && (accumulator!.truncatingRemainder(dividingBy: 1) != 0) {
            smallAccumulator = String(format: "%.3f", accumulator!)
        } else if accumulator != nil {
            smallAccumulator = String(accumulator!)
        }
        
        if let operation = operations[symbol] {
            switch  operation {
            case .constant(let value):
                if resultIsPending != true { description = nil}
                valueToAppend = String(format: "%.3f", value)
            case .unaryOperation:
                if accumulator != nil {
                    if resultIsPending != false {
                        valueToAppend = "\(symbol)\(smallAccumulator!)"
                    } else {
                        valueToAppend = "\(symbol)(\(description!))"
                    }
                }
                if resultIsPending != true { description = nil}
            case .binaryOperation:
                if resultIsPending != true { description = nil}
                if accumulator != nil { valueToAppend = "\(smallAccumulator!)\(symbol)"}
            case .equals:
                if accumulator != nil { valueToAppend = "\(smallAccumulator!)"}
            }
        }
        
        if valueToAppend != nil && description != nil {
            description = description! + valueToAppend!
        } else if valueToAppend != nil {
            description = valueToAppend!
        }
        if description != nil { print("description \(description!)")}
    }
    
//    mutating func setDescription(_ symbol: String) {
//        if description != nil && accumulator != nil {
//            description = description! + String(accumulator!) + " \(symbol) "
//        } else if accumulator != nil {
//            description = String(accumulator!) + " \(symbol) "
//        }
//        
//        lastDescription = description ?? " "
//        if accumulator != nil { print("accumulator \(accumulator!)")} else { print("accumulator is nil")}
//        if description != nil { print("description \(description!)")}
//    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        } //you dont put set, so it becomes read only property
    }
    
    mutating func reset() {
        resultIsPending = false
        accumulator = nil
        description = nil
        lastDescription = description ?? " "
    }
    
}
