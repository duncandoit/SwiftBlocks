//
//  MessageBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class MessageBlock: NSObject, Block, UITextViewDelegate {
    // MARK: - Block Properties

    var state: State = .view
    weak var observer: Observer?
    var isValid: Bool = true
    var modified: Bool { currentMessage != originalMessage }
    var label: String?
    var required: Bool = false
    var hidden: Bool = false
    var enabled: Bool = false
    weak var viewController: UIViewController?
    var primaryColor: UIColor = .systemBackground
    var primaryTextColor: UIColor = .systemGray
    var secondaryColor: UIColor = .secondarySystemBackground
    var secondaryTextColor: UIColor = .systemGray2

    // MARK: - MessageBlock Properties
    
    var hideLabel: Bool = false
    var currentMessage: String?
    var originalMessage: String?
    var messageAlignment: NSTextAlignment = .left
    
    /// The maximum number of characters which can be entered
    /// into the cell(in:)'s textView
    var maxLength: Int?
    
    // MARK: - Init
    
    init(_ message: String? = nil) {
        if let message = message {
            currentMessage = message
            originalMessage = message
        }
    }

    // MARK: - Text View Methods

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Assemble the edited text into its final arrangement
        if let string = textView.text, let textRange = Range(range, in: string) {
            let updatedInput = string.replacingCharacters(in: textRange, with: text)

            // Ensure the max length is not exceeded
            if let maxLength = maxLength {
                if updatedInput.count > maxLength {
                    animateError(in: textView)
                    return false
                }
            }

            // This is just QoL - ensuring no mismatch between nil and empty
            if updatedInput.isEmpty && originalMessage == nil {
                currentMessage = nil
            } else {
                currentMessage = updatedInput
            }
        } else {
            return false
        }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        observer?.update()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        currentMessage = textView.text
    }

    // MARK: - TextView Helper Methods

    private func animateError(in textView: UITextView) {
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            textView.backgroundColor = self.secondaryColor
        }) { _ in
            UIView.animate(withDuration: 0.1) { [unowned self] in
                textView.backgroundColor = self.primaryColor
            }
        }
    }

    // MARK: - Views

    func cell(in tableView: UITableView) -> UITableViewCell {
        tableView.register(UINib(nibName: "MessageBlockCell", bundle: nil), forCellReuseIdentifier: "MessageBlock")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBlock") as? MessageBlockCell else { return UITableViewCell() }
        
        cell.isUserInteractionEnabled = enabled
        cell.selectionStyle = .none

        cell.titleLabel.text = label
        cell.titleLabel.isHidden = hideLabel
        cell.titleLabel.textColor = primaryTextColor
        
        cell.message.delegate = self
        cell.message.text = currentMessage
        cell.message.isScrollEnabled = false
        cell.message.textAlignment = messageAlignment
        
        if state == .view || state == .locked {
            cell.message.backgroundColor = primaryColor
            cell.message.textColor = primaryTextColor
        } else {
            cell.message.backgroundColor = secondaryColor
            cell.message.textColor = secondaryTextColor
        }

        return cell
    }
}
