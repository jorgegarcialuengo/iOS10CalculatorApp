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

    private var accumulator: Double?
    
    var resultIsPending = false
    
    private var description: String? = ""
    
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
        
        if let operation = operations[symbol] {
            
            switch  operation {
            case .constant(let value):
                accumulator = value
                if resultIsPending == true {
                     description?.append(symbol)
                } else {
                    description = symbol
                }
            case .unaryOperation(let funcion):
                if accumulator != nil{
                    if resultIsPending == true {
                        let numberString: String? = String(accumulator!)
                        let stringLength = numberString!.characters.count
                        description = String(description!.characters.dropLast(stringLength))
                        description = "\(description!)\(symbol)(\(numberString!))"
                    } else {
                        description = "\(symbol)(\(description!))"
                    }
                    accumulator = funcion(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    description?.append(symbol)
                    accumulator = nil
                    
                    if resultIsPending != true {resultIsPending = true}
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
            }
        }
        lastDescription = description

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
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if resultIsPending != true {
            description = ""
        }
        description?.append(String(operand))
    }
    
    var result: Double? {
        get {
            return accumulator
        } //you dont put set, so it becomes read only property
    }
    
    mutating func reset() {
        resultIsPending = false
        accumulator = nil
        description = ""
        lastDescription = description ?? " "
    }
    
}
