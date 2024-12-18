//
//  ProfileBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//
//
//import Foundation
//
//class ProfileBlock: Block {
//    // MARK: - Block Properties
//    
//    weak var observer: Observer?
//    var id: NSNumber = 0
//    var isValid: Bool = true
//    var modified: Bool = false
//    var label: String?
//    var required: Bool = false
//    var hidden: Bool = false
//    var enabled: Bool = true
//
//    // MARK: - ProfileBlock Properties
//    
//    var client: CBHCaseLoad
//    
//    // MARK: - INIT
//    
//    init(client: CBHCaseLoad) {
//        self.client = client
//    }
//    
//    // MARK: - Views
//    
//    var viewController: UIViewController? {
//        // TODO: Use the Client Details View Controller for other areas of the app that use it
//        return nil
//    }
//    
//    func cell(in tableView: UITableView) -> UITableViewCell {
//        tableView.register(UINib(nibName: "EVVClientCell", bundle: nil), forCellReuseIdentifier: "EVVClientCell")
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EVVClientCell") as? EVVClientCell else { return UITableViewCell() }
//        
//        cell.clientPhoto.image = client.profileImage
//        cell.clientName.text = client.fullName()
//        cell.selectionStyle = enabled ? .default : .none
//        
//        if let dob = client.dateOfBirth { cell.clientDOB.text = DateFormatter().string(from: dob) }
//        else { cell.clientDOB.text = nil }
//        
//        return cell
//    }
//}
