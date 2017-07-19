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
    
    var userIsInTheMiddleOfTyping = false
    
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
            let format = NumberFormatter()
            format.maximumFractionDigits = 6
            display.text = format.string(for: newValue)
            ///display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func randomNumber(_ sender: UIButton) {
        let randomNumber: Float32 = Float32((arc4random() % 10))
        let otherNum = randomNumber/10
        display.text = String(otherNum)
        brain.setOperand(displayValue)
        print(otherNum)
        
    }
    
    
    
    @IBAction func eraseLastDigit(_ sender: Any) {
        if userIsInTheMiddleOfTyping == false || display.text!.characters.count == 1 {
            brain.reset()
            display.text = "0"
            descriptionLabel.text = ""
            userIsInTheMiddleOfTyping = false
        } else {
            display.text!.remove(at: display.text!.index(before: display.text!.endIndex))
            brain.setOperand(displayValue)
        }
    }
    
    @IBAction func resetAll(_ sender: Any) {
        brain.reset()
        display.text = "0"
        descriptionLabel.text = ""
        userIsInTheMiddleOfTyping = false
        
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

