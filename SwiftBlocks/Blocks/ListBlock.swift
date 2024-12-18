//
//  ListBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

//import UIKit
//
//class ListBlock: NSObject, Block, DropdownDelegate {
//    // MARK: - Block Properties
//    
//    weak var observer: Observer?
//    var id: NSNumber
//    var isValid: Bool { return currentSelection != nil }
//    var modified: Bool = false
//    var label: String?
//    var required: Bool = false
//    var hidden: Bool = false
//    var enabled: Bool = true
//    
//    // MARK: - ListBlock Properties
//    
//    var currentSelection: [DropdownItem]?
//    var originalSelection: [DropdownItem]?
//    
//    /// The values to be listed in the viewController
//    var selectionItems: [DropdownItem]?
//    
//    /// Whether the list of selectionOptions showed in the viewController can be
//    /// filtered using a searchBar
//    var searchable: Bool = false
//    
//    var preSort: Bool = false
//    var allowsDeselect: Bool = false
//    var allowsMultiselect: Bool = false
//    
//    // MARK: - INIT
//    
//    init(ID: NSNumber) {
//        id = ID
//    }
//    
//    // MARK: - DropdownDelegate Methods
//    
//    func dropDownDidSelect(_ item: DropdownItem?) {
//        guard let item = item else { return }
//        currentSelection = [item]
//        modified = true
//    }
//    
//    func dropDownDidSelectItems(_ items: [Any]?) {
//        guard let items = items as? [DropdownItem] else { return }
//        currentSelection = items
//        modified = true
//    }
//    
//    // MARK: - Views
//    
//    var viewController: UIViewController? {
//        guard let dropdownVC = CBHDropdownViewController(style: .grouped) else { return nil }
//        
//        dropdownVC.selectionValues = selectionItems
//        dropdownVC.includeSearch = searchable
//        dropdownVC.shouldSort = !preSort
//        dropdownVC.allowsDeselect = allowsDeselect
//        dropdownVC.title = label
//        dropdownVC.delegate = self
//        dropdownVC.multiSelection = allowsMultiselect
//        
//        if let count = currentSelection?.count {
//            if count == 1 {
//                dropdownVC.preselectedValues = currentSelection?.first?.dropdownValue()
//            } else if count > 1 {
//                var values: [NSNumber] = []
//                for selection in currentSelection ?? [] {
//                    values.append(selection.dropdownValue())
//                }
//                dropdownVC.preselectedValues = values
//            }
//        }
//        
//        return dropdownVC;
//    }
//    
//    func cell(in tableView: UITableView) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
//        
//        cell.textLabel?.textAlignment = .left
//        cell.accessoryType = enabled ? .disclosureIndicator : .none
//        
//        if let count = currentSelection?.count {
//            if count == 1 {
//                cell.detailTextLabel?.text = currentSelection?.first?.dropdownDisplayText()
//            }
//            else if count == 1 {
//                cell.detailTextLabel?.text = "\(count)"
//            }
//        }
//        
//        if required {
//            cell.textLabel?.attributedText = requiredLabel
//        } else {
//            cell.textLabel?.text = label
//        }
//            
//        cell.isUserInteractionEnabled = enabled
//        
//        return cell
//    }
//}
