//
//  EVVConfirmationController.swift
//  Care
//
//  Created by Zachary Duncan on 11/12/19.
//  Copyright © 2019 Zachary Duncan. All rights reserved.
//

import UIKit

@objcMembers
class EVVConfirmationController: ContainerTableController {
    weak var delegate: EVVConfirmationDelegate?
    var confirmationForm: EVVConfirmationForm? { return container as? EVVConfirmationForm }
    var evvEvent: EVVEvent?
    
    override func viewDidLoad() {
        swipeToDismiss = false
        super.viewDidLoad()
        
        leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    @objc func save() {
        if let invalidQuestion = confirmationForm?.invalidQuestion {
            showAlert(message: "The " + invalidQuestion + " is required")
        } else {
            var emp: SignatureQuestion? { return confirmationForm?.employeeSignature }
            var client: SignatureQuestion? { return confirmationForm?.clientSignature }
            
            evvEvent?.endVerification(es: emp?.currentSignature, en: emp?.currentName,
                                      cs: client?.currentSignature, cn: client?.currentName)
            
            dismiss(animated: true) { [weak self] in
                self?.delegate?.useEVVSignatures = self?.confirmationForm?.signatureToggle.isOn ?? false
                self?.delegate?.update()
            }
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

@objc protocol EVVConfirmationDelegate {
    var useEVVSignatures: Bool { get set }
    func update()
}
