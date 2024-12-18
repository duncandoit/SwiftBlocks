//
//  TextFieldFormField.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

@objcMembers
class TextFieldBlock: NSObject, Block, UITextFieldDelegate {
    // MARK: - Block Properties
    
    var state: State = .view
    weak var observer: Observer?
    var isValid: Bool { return currentInput != nil && currentInput != "" }
    var modified: Bool { return currentInput != originalInput }
    var label: String?
    var required: Bool = false
    var hidden: Bool = false
    var enabled: Bool = true
    var primaryColor: UIColor = .white
    var secondaryColor: UIColor = .init(white: 1, alpha: 0.5)
    var primaryTextColor: UIColor = .black
    var secondaryTextColor: UIColor = .gray
    
    // MARK: - TextFieldBlock Properties
    
    var currentInput: String?
    var originalInput: String?
    
    /// If true the keyboard layout will change to only allow numeric input
    var isNumeric: Bool = false
    
    /// Characters that are allowed when isNumeric is true
    private let nonNumericCharSet = CharacterSet(charactersIn: "0123456789-+*/=%#.,$()^ ").inverted
    
    /// Text to prompt the user's input
    var placeholder: String = ""
    
    /// The maximum number of characters that can be contained by currentValue and the associated UITextField
    var maxLength: Int?
    
    // MARK: - TextField Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ensure input is numeric if required
        if isNumeric {
            if string.rangeOfCharacter(from: nonNumericCharSet) != nil {
                animateError(in: textField)
                return false
            }
        }
        
        // Assemble the edited text into its final arrangement
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedInput = text.replacingCharacters(in: textRange, with: string)
            
            // Ensure the max length is not exceeded
            if let maxLength = maxLength {
                if updatedInput.count > maxLength {
                    animateError(in: textField)
                    return false
                }
            }
            
            currentInput = updatedInput
        } else {
            return false
        }

        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        currentInput = nil
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentInput = textField.text
        textField.placeholder = placeholder
    }
    
    // MARK: - TextField Helper Methods
    
    private func animateError(in textField: UITextField) {
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            textField.backgroundColor = self.secondaryColor
        }) { success in
            UIView.animate(withDuration: 0.1) { [unowned self] in
                textField.backgroundColor = self.primaryColor
            }
        }
    }
    
    // MARK: - Views
    
    var viewController: UIViewController? { return nil }
    
    func cell(in tableView: UITableView) -> UITableViewCell {
        tableView.register(UINib(nibName: "TextFieldBlockCell", bundle: nil), forCellReuseIdentifier: "TextFieldBlock")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldBlock") as? TextFieldBlockCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.textField.alpha = enabled ? 1 : 0.5
        cell.textField.placeholder = placeholder
        cell.textField.delegate = self
        cell.textField.keyboardType = isNumeric ? .numbersAndPunctuation : .default
        cell.textField.placeholder = enabled ? placeholder : ""
        cell.isUserInteractionEnabled = enabled
        
        if required {
            cell.title.attributedText = requiredLabel
        } else {
            cell.title.text = label
        }
        
        return cell
    }
}

/// The custom look and behavior for the UITextField used in TextFieldBlock
class BlockTextField: UITextField {
    override func awakeFromNib() {
        preservesSuperviewLayoutMargins = true
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: bounds.width * 0.4, bottom: 0, right: layoutMargins.right))
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: bounds.width * 0.4, bottom: 0, right: layoutMargins.right))
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: bounds.width * 0.4, bottom: 0, right: 30))
    }
}
