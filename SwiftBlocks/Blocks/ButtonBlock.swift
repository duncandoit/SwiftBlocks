//
//  ButtonBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class ButtonBlock: Block, Selectable {
    // MARK: - Block Properties
    
    var state: State = .view
    weak var observer: Observer?
    var isValid: Bool = true
    var modified: Bool = false
    var label: String?
    var required: Bool = false
    var hidden: Bool = false
    var enabled: Bool = true
    var primaryColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    var secondaryColor: UIColor = .init(white: 1, alpha: 0.5)
    var primaryTextColor: UIColor = .white
    var secondaryTextColor: UIColor = .gray
    
    // MARK: - Selectable Properties
    
    var selectionAction: (() -> Void)?
    
    // MARK: - INIT
    
    init(label: String) {
        self.label = label
    }
    
    // MARK: - Views
    
    var viewController: UIViewController? { return nil }
    
    func cell(in tableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = label
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = enabled ? primaryTextColor : primaryTextColor.withAlphaComponent(0.5)
        cell.backgroundColor = enabled ? primaryColor : primaryColor.withAlphaComponent(0.5)
        cell.isUserInteractionEnabled = enabled
        
        return cell
    }
}
