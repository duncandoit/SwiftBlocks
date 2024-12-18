//
//  MultilineTextFieldBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

fileprivate var kMultilineTextFieldBlockCell = "MultilineTextFieldBlockCell"

class MultilineTextFieldBlock: TextFieldBlock, UITextViewDelegate {
    
    override func cell(in tableView: UITableView) -> UITableViewCell {
        tableView.register(MultilineTextFieldBlockCell.self,
                           forCellReuseIdentifier: kMultilineTextFieldBlockCell)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kMultilineTextFieldBlockCell) as? MultilineTextFieldBlockCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.textField.alpha = enabled ? 1 : 0.5
        cell.textField.keyboardType = isNumeric ? .numbersAndPunctuation : .default
        cell.textField.delegate = self
        cell.isUserInteractionEnabled = enabled
        
        if required {
            cell.title.attributedText = requiredLabel
        } else {
            cell.title.text = label
        }
        
        return cell
    }
    
    func textViewDidChange(_ textView: UITextView) {
        currentInput = textView.text ?? nil
    }
}


class MultilineTextFieldBlockCell: UITableViewCell {
    
    lazy var title: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextView! = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.94897001979999995,
                                       green: 0.94905406240000001,
                                       blue: 0.94889980549999997,
                                       alpha: 1)
        return view
    }()
    
    // MARK: - Lifespan
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper methods
    
    private func setupUI() {
        selectionStyle = .none
        
        addSubview(title)
        addSubview(textField)
        
        addConstraints([
            leftAnchor.constraint(equalTo: title.leftAnchor, constant: -15),
            topAnchor.constraint(equalTo: title.topAnchor, constant: -11),
            topAnchor.constraint(equalTo: textField.topAnchor, constant: -5),
            rightAnchor.constraint(equalTo: textField.rightAnchor, constant: 15),
            title.rightAnchor.constraint(equalTo: textField.leftAnchor, constant: -10),
            bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
        ])
    }
    
}
