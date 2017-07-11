//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jorge García-Luengo on 10/7/17.
//  Copyright © 2017 Jorge García-Luengo. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

struct CalculatorBrain {
    //clasees have inheritances, structs do not
    //classes live in the heap, and you have pointers to them, structs don't so they are copyed around
    //any method that changes the value of a variable has to be marked muttating

    private var accumulator: Double? // private because it's for internal use only
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cons" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation(changeSign)
    ]

    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch  operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation:
                break
            }
            //accumulator = constant
        }
        
        
//        switch symbol {
//        case "π":
//            accumulator = Double.pi //display.text = String(Double.pi)   //"\(Double.pi)" could work too
//        case "√":
//            if let operand = accumulator {
//                accumulator = sqrt(operand)
//            }
//            //let operand = Double(display.text!)!
//            //display.text = String(sqrt(operand))
//            //making some changes
//        default:
//            break
//        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        
    }
    
    var result: Double? {
        get {
            return accumulator
        } //you dont put set, so it becomes read only property
    }
    
}
