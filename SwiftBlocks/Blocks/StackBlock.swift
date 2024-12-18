//
//  StackBlock.swift
//  Battle for Lighthall
//
//  Created by Zachary Duncan on 4/20/21.
//

import UIKit

class StackBlock: Block {
    // MARK: - StackBlock Properties
    
    var views: [UIView] = []
    
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
    
    // MARK: - Views
    
    var viewController: UIViewController? { return nil }
    
    func cell(in tableView: UITableView) -> UITableViewCell {
        tableView.register(UINib(nibName: "StackBlockCell", bundle: nil), forCellReuseIdentifier: "StackBlockCell")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StackBlockCell") as? StackBlockCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        for view in views {
            cell.stackView.addArrangedSubview(view)
        }
        
        return cell
    }
}

class StackBlockCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
}
