//
//  ViewController.swift
//  Calculator
//
//  Created by Jorge García-Luengo on 7/7/17.
//  Copyright © 2017 Jorge García-Luengo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!  //? se use ! instead of ?, an inplicitly unwrap optional. Now we dont have to write display! every time
    
    var userIsInTheMiddleOfTyping = false // : Bool = false is how should do it, but Xcode can guess false can only be a Bool
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! // use ! to reach the set value. It will crash if value is not set
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit == "." && textCurrentlyInDisplay.contains(".")) {
                print("do nothin, is a .")
            } else {
                display.text = textCurrentlyInDisplay + digit }
        } else {
            if digit == "." { display.text = "0" + digit } else { display.text = digit }
            userIsInTheMiddleOfTyping = true
        }
        
        
        //print("\(digit) was called") // use \(variable) to print it's content
     }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func resetAll(_ sender: Any) {
        brain.reset()
        display.text = "0"
        descriptionLabel.text = ""
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
        if brain.lastDescription != nil {
            if brain.resultIsPending {
                descriptionLabel.text = brain.lastDescription! + "..."
            } else {
                descriptionLabel.text = brain.lastDescription! + "="
            }
        }
    }
    
}

