//
//  SignatureBlock.swift
//  SwiftBlocks
//
//  Created by Zachary Duncan on 6/15/20.
//  Copyright © 2020 Zachary Duncan. All rights reserved.
//

//import Foundation
//
//@objcMembers
//class SignatureBlock: NSObject, Block, SignatureViewDelegate, CBHSignatureViewControllerDelegate {
//    // MARK: - Block Properties
//
//    weak var observer: Observer?
//    let id: NSNumber = 0
//    var isValid: Bool { return currentSignature != nil && currentSignature != "" }
//    var modified: Bool { return currentSignature != originalSignature || currentName != originalName }
//    var label: String? = "Signature"
//    var required: Bool = false
//    var hidden: Bool = false
//    var enabled: Bool = true
//
//    // MARK: - SignatureBlock Properties
//
//    /// This will store the data given by the user
//    var currentSignature: String? = "" { didSet { observer?.update() } }
//
//    /// This stores the last saved state of the user data
//    var originalSignature: String? = ""
//
//    /// This will store the name of the person signing
//    var currentName: String = "" { didSet { observer?.update() } }
//
//    /// This stores the last saved state of the name of the person signing
//    var originalName: String = ""
//
//    /// A UIImage encoded from the the base64 String of the currentValue
//    var signatureImage: UIImage? { return currentSignature?.imageValue }
//
//    /// When in a list of signatures, this determines its order
//    var displayOrder: Int?
//
//    /// The type of person signing
//    var type: CBHSignatureType = .SignatureTypeGeneral
//
//    /// This reflects the date when the signature was last modified
//    var dateSigned: Date?
//
//    /// This is a String representation of the dateSigned
//    var dateSignedString: String {
//        guard let time = dateSigned else { return "" }
//        return DateFormat.stringFrom(date: time, format: .json)
//    }
//
//    // MARK: - Delegate Methods
//
//    func signatureViewTouchesBegan(_ view: CBHSignatureView?) {
//        // ...
//    }
//
//    func signatureViewTouchesEnded(_ view: CBHSignatureView?) {
//        guard let signatureView = view else { return }
//
//        let signatureImage: UIImage = signatureView.getSignatureImage()
//        let signatureString: String? = signatureImage.base64String
//        currentSignature = signatureString
//    }
//
//    func signatureControllerDidChangeSignature(_ signature: UIImage) {
//        guard let signatureString = signature.base64String else { return }
//        guard currentSignature != signatureString else { return }
//
//        currentSignature = signatureString
//        dateSigned = Date()
//    }
//
//    func signatureControllerDidChangePrintName(_ printName: String) {
//        currentName = printName
//    }
//
//    // MARK: - Views
//
//    var viewController: UIViewController? {
//        let signatureVC = CBHSignatureViewController(style: .grouped)
//        signatureVC.baseSignature = currentSignature ?? ""
//        signatureVC.printedName = currentName
//        signatureVC.signatureType = type
//        signatureVC.delegate = self
//
//        return signatureVC
//    }
//
//    func cell(in tableView: UITableView) -> UITableViewCell {
//        tableView.register(UINib(nibName: "CBHSignatureCell", bundle: nil), forCellReuseIdentifier: "SignatureCell")
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SignatureCell") as? CBHSignatureCell else { return UITableViewCell() }
//
//        if required {
//            cell.signatureTitleLabel.attributedText = requiredLabel
//        } else {
//            cell.signatureTitleLabel.text = label
//        }
//
//        cell.signatureImageView.image = signatureImage
//        cell.signatureTitleLabel.isEnabled = enabled
//        cell.isUserInteractionEnabled = enabled
//
//        return cell
//    }
//}
