//
//  Block.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

protocol Block {
    var state: State { get set }
    
    /// Set this as the Container that will receive updates when crucial attributes change
    var observer: Observer? { get set }
    
    /// Indicates if basic criteria has been met by the user in this Block
    var isValid: Bool { get }
    
    /// Indicates if this Block has been modified since last saving
    var modified: Bool { get }
    
    /// The title of this Block. It will display in table cells and view controller titles
    var label: String? { get set }

    /// Indicates if this Block is required by its containing Container to have a value
    ///
    /// When true this Block must have a non-nil currentValue else the corresponding Container will be invalid.
    var required: Bool { get set }

    /// Indicates if this Block will be displayed in the Container
    var hidden: Bool { get set }

    /// Indicates if this Block will be user-interactable
    var enabled: Bool { get set }
    
    /// The UIViewController that represents the detail for a Block
    ///
    /// Not all Blocks have a detail UIViewController and will return nil in those cases
    var viewController: UIViewController? { get }
    
    /// The default color used for the Block's cell background
    var primaryColor: UIColor { get set }
    
    /// The default color used for the Block's cell textColor
    var primaryTextColor: UIColor { get set }
    
    /// The default color used for the Block's viewController background
    var secondaryColor: UIColor { get set }
    
    /// The default color used for the Block's viewController textColor
    var secondaryTextColor: UIColor { get set }
    
    // TODO: Refactor Blocks to have a view property rather than just a cell()
    //       That way it can be added to a UITableViewCell, UICollectionViewCell or
    //       just added to a UIViewController's subviews. Much more flexable
    //       For example: this would allow having a .xib used for a header Block cell and
    //       also used for a UITableView's section header view. Keeps things unified
    /// The UITableViewCell formatted for the Block
    func cell(in tableView: UITableView) -> UITableViewCell
}

extension Block {
    /// Returns formatted text to be used as the Block's label when it is required
    var requiredLabel: NSMutableAttributedString {
        let requiredLabel = (label ?? "") + " ﹡"
        let attributedLabel = NSMutableAttributedString(string: requiredLabel)
        let range = NSRange(location: label?.count ?? 0, length: 2)
        attributedLabel.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        return attributedLabel
    }
}

protocol Selectable {
    /// An action to be performed when the object is selected by the user
    var selectionAction: (()->Void)? { get set }
}
