//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jorge García-Luengo on 10/7/17.
//  Copyright © 2017 Jorge García-Luengo. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    //clasees have inheritances, structs do not
    //classes live in the heap, and you have pointers to them, structs don't so they are copyed around
    //any method that changes the value of a variable has to be marked muttating

    private var accumulator: Double? // private because it's for internal use only
    
    func performOperation(_ symbol: String) {
        
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
