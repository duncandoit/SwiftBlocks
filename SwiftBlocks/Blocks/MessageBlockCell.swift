//
//  MessageBlockCell.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

import UIKit

class MessageBlockCell: UITableViewCell, Observer {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var message: UITextView!

    override var isUserInteractionEnabled: Bool {
        didSet {
            message.backgroundColor = isUserInteractionEnabled ? .gray : UIColor.white
        }
    }

    func update() { }
}
