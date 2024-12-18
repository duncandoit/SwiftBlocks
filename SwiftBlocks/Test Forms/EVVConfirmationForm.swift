//
//  EVVConfirmationForm.swift
//  Care
//
//  Created by Zachary Duncan on 11/12/19.
//  Copyright © 2019 Zachary Duncan. All rights reserved.
//

import Foundation

@objcMembers
class EVVConfirmationForm: ScheduleItemForm {
    var employeeSignature: SignatureQuestion
    var clientSignature: SignatureQuestion
    var signatureToggle: ToggleQuestion

    init(with programID: NSNumber, and serviceTypeID: NSNumber, for client: CBHCaseLoad, in state: State, evvEvent: EVVEvent?) {
        signatureToggle = ToggleQuestion(ID: 0, toggledOn: false)
        employeeSignature = SignatureQuestion()
        clientSignature = SignatureQuestion()

        super.init(with: programID, and: serviceTypeID, for: client, in: state)

        // MARK: Section 0

        let clientProfile = ClientProfileQuestion(client: client)
        clientProfile.enabled = false

        // MARK: Section 1

        let startDate = DateQuestion(ID: 1)
        startDate.currentDate = evvEvent?.startDate
        startDate.format = .both
        startDate.label = "Start Date"
        startDate.enabled = false
        startDate.observer = self

        let endDate = DateQuestion(ID: 1)
        endDate.currentDate = Date()
        endDate.format = .both
        endDate.label = "End Date"
        endDate.enabled = false
        endDate.observer = self

        // MARK: Section 2

        let legalMessage = MessageQuestion(ID: 0)
        if let legalText = CBHPartnerConfig.sharedInstance()?.evvConfirmationStatement {
            legalMessage.currentMessage = legalText
        } else {
            legalMessage.hidden = true
        }

        // MARK: Section 3

        signatureToggle.label = "Use signatures on for sign and submit"

        employeeSignature.displayOrder = 0
        employeeSignature.label = (CBHPartnerConfig.sharedInstance()?.employeeLabel ?? "Employee") + " Signature"
        employeeSignature.type = .SignatureTypeEmployee
        employeeSignature.observer = self

        clientSignature.displayOrder = 1
        clientSignature.label = (CBHPartnerConfig.sharedInstance()?.customerLabel ?? "Client") + " Signature"
        clientSignature.type = .SignatureTypeClient
        clientSignature.required = CBHPartnerConfig.sharedInstance()?.evvClientSignatureRequired ?? false
        clientSignature.observer = self

        let section0 = FormSection(questions: [clientProfile])
        let section1 = FormSection(questions: [startDate, endDate])
        let section2 = FormSection(questions: [legalMessage])
        let section3 = FormSection(questions: [signatureToggle, employeeSignature, clientSignature])

        sections = [section0, section1, section2, section3]
    }
}
