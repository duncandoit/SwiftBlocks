//
//  ContainerBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class ContainerBlock: NSObject, Block, Selectable {
    // MARK: - Block Properties
    
    var state: State = .view
    weak var observer: Observer?
    var isValid: Bool { return container?.invalidBlock == nil }
    var modified: Bool = false
    var label: String?
    var required: Bool = false
    var hidden: Bool = false
    var enabled: Bool = true
    var primaryColor: UIColor = .systemBackground
    var primaryTextColor: UIColor = .systemBlue
    var secondaryColor: UIColor = .secondarySystemBackground
    var secondaryTextColor: UIColor = .systemTeal
    
    // MARK: - ContainerBlock Properties
    
    /// The Container that will be displayed by a the viewController
    /// property as a ContainerController
    var container: Container?
    
    /// A non-optional array of sections in the Container property
    var sections: [ContainerSection] { return container?.sections ?? [] }
    
    // MARK: - Selectable Properties
    
    var selectionAction: (() -> Void)?
    
    // MARK: - Views
    
    var viewController: UIViewController? {
        let containerVC = ContainerController()
        containerVC.title = label
        
        container?.primaryColor = primaryColor
        container?.secondaryColor = secondaryColor
        container?.primaryTextColor = primaryTextColor
        container?.secondaryTextColor = secondaryTextColor
        
        containerVC.container = container
        
        return containerVC;
    }
    
    func cell(in tableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.textAlignment = .left
        cell.backgroundColor = container?.secondaryColor
        cell.textLabel?.textColor = container?.secondaryTextColor
        cell.textLabel?.backgroundColor = .clear
        
        cell.accessoryType = enabled ? .disclosureIndicator : .none
        
        if required {
            cell.textLabel?.attributedText = requiredLabel
        } else {
            cell.textLabel?.text = label
        }
        
        cell.isUserInteractionEnabled = enabled
        
        return cell
    }
}
