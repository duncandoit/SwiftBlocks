//
//  DateBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

//import UIKit
//
//@objcMembers
//class DateBlock: NSObject, Block, TimePickerDelegate {
//    // MARK: - Block Properties
//
//    weak var observer: Observer?
//    var id: NSNumber
//    var isValid: Bool { return currentDate != nil }
//    var modified: Bool { return currentDate != originalDate }
//    var label: String? = "Date"
//    var required: Bool = false
//    var hidden: Bool = false
//    var enabled: Bool = true
//
//    // MARK: - DateBlock Properties
//
//    var currentDate: Date?
//    var originalDate: Date?
//
//    /// If true this will make the cell display the month, day, year and timestamp
//    var format: DisplayFormat = .date
//
//    // MARK: - INIT
//
//    init(ID: NSNumber) {
//        id = ID
//    }
//
//    // MARK: - Delegate Methods
//
//    func timePickerDidSelect(_ date: Date!) {
//        let date = date.startOfDay
//        guard currentDate != date else { return }
//        currentDate = date
//    }
//
//    // MARK: - Date Display Options
//
//    enum DisplayFormat {
//        case date
//        case time
//        case both
//    }
//
//    // MARK: - Views
//
//    var viewController: UIViewController? {
//        let dateController = CBHTimePickerViewController()
//
//        dateController.preselectedDate = currentDate
//        dateController.datePickerMode = .date
//        dateController.delegate = self
//
//        return dateController
//    }
//
//    func cell(in tableView: UITableView) -> UITableViewCell {
//        tableView.register(UINib(nibName: "CBHFormValueCell", bundle: nil), forCellReuseIdentifier: "ValueCell")
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ValueCell") as? CBHFormValueCell else { return UITableViewCell() }
//
//        if required {
//            cell.textLabel?.attributedText = requiredLabel
//        } else {
//            cell.textLabel?.text = label
//        }
//
//        switch format {
//        case .date:
//            cell.detailTextLabel?.text = currentDate?.displayString
//        case .time:
//            cell.detailTextLabel?.text = currentDate?.timeStampDisplayString
//        case .both:
//            cell.detailTextLabel?.text = currentDate?.fullLengthDisplayString
//        }
//
//        cell.isUserInteractionEnabled = enabled
//        cell.lineColor = nil
//        cell.imageView?.image = nil
//        cell.accessoryType = enabled ? .disclosureIndicator : .none
//
//        return cell
//    }
//}
