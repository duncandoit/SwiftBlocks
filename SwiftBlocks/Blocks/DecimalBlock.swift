//
//  DecimalBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class DecimalBlock: TextFieldBlock {
    // MARK: - TextFieldBlock Properties
    
    override var modified: Bool { return currentDecimal != originalDecimal }
    
    // MARK: - DecimalBlock Properties
    
    /// This will store the data given by the user
    var currentDecimal: Double? { didSet { observer?.update() } }

    /// This stores the last saved state of the user data
    var originalDecimal: Double?
    
    /// Contains a specially formatted String to be given to NSPredicate to evaluate
    var regex: String?
    
    /// Whether the associated TextField should display a 0 when empty
    var defaultZero: Bool = true
    
    /// The maximum number of digits after a decimal point for the displayValue to show
    var maxFractionDigits: Int?
    
    /// The minimum number of digits after a decimal point for the displayValue to show
    var minFractionDigits: Int?
    
    /// Characters that are allowed to be input by this Block type
    private let nonNumericCharSet = CharacterSet(charactersIn: "0123456789.").inverted
    
    // MARK: - Delegate Methods
    
    func textFieldControllerValueSelected(_ value: [AnyHashable : Any]!) {
        //currentDecimal = value["???"] as? Double
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == "." {
            textField.text = "0."
            currentDecimal = 0.0
            return false
        }
        
        var newValue = (textField.text ?? "") + string
        newValue = newValue.components(separatedBy: nonNumericCharSet).joined(separator: "")
        
        var valid = true
        if let regex = regex {
            let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
            valid = test.evaluate(with: newValue)
        }
        if valid {
            textField.text = newValue
            currentDecimal = Double(newValue)
        }
        
        return false
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.hasSuffix(".") {
                textField.text! += "0"
            }
        }
        
        let notEmpty = !(textField.text?.isEmpty ?? true)
        
        if notEmpty {
            currentDecimal = Double(textField.text!)
        } else if defaultZero {
            currentDecimal = 0.0
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        observer?.update()
        return true
    }
}
