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
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! // use ! to reach the set value. It will crash if value is not set
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
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
    
    @IBAction func performOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
            case "π":
                displayValue = Double.pi //display.text = String(Double.pi)   //"\(Double.pi)" could work too
            case "√":
                displayValue = sqrt(displayValue)
                //let operand = Double(display.text!)!
                //display.text = String(sqrt(operand))
                //making some changes
                
            default:
                break
            }
        }
    }
    
    
    
}

