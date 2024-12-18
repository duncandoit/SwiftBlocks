//
//  ToggleBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class ToggleBlock: Block {
    // MARK: - Block Properties
    
    var state: State = .view
    weak var observer: Observer?
    var isValid: Bool = true
    var modified: Bool { return isOn != wasOriginallyOn }
    var label: String?
    var required: Bool = false
    var hidden: Bool = false
    var enabled: Bool = true
    var primaryColor: UIColor = .white
    var secondaryColor: UIColor = .init(white: 1, alpha: 0.5)
    var primaryTextColor: UIColor = .black
    var secondaryTextColor: UIColor = .gray
    
    // MARK: - ToggleBlock Properties
    
    private let toggle: UISwitch = UISwitch()
    var isOn: Bool
    var wasOriginallyOn: Bool
    
    // MARK: - INIT
    
    init(toggledOn: Bool) {
        wasOriginallyOn = toggledOn
        isOn = toggledOn
        toggle.isOn = toggledOn
    }
    
    // MARK: - Views
    
    var viewController: UIViewController? = nil
    
    func cell(in tableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        isOn = toggle.isOn
        toggle.isEnabled = enabled
        toggle.addTarget(observer, action: #selector(observer?.update), for: .valueChanged)
        cell.textLabel?.text = label
        cell.accessoryView = toggle
        cell.selectionStyle = .none
        
        return cell
    }
}
