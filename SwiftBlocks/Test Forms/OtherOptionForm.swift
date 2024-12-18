////
////  OtherOptionForm.swift
////  Care
////
////  Created by Nikola Ristic on 23/01/2020.
////  Copyright © 2020 Zachary Duncan. All rights reserved.
////
//
//import Foundation
//
//fileprivate let strReason = "Reason"
//fileprivate let strReasonPlaceholder = "Enter reason description"
//
//class OtherOptionForm: ScheduleItemForm {
//    
//    let reason = MessageQuestion(ID: 0)
//    
//    init(client: CBHCaseLoad) {
//        super.init(with: 0, and: 0, for: client, in: EditState())
//        
//        reason.label = strReason
//        reason.enabled = true
//        reason.observer = self
//        reason.required = true
//        
//        let section1 = FormSection(questions: [reason])
//        
//        sections = [section1]
//    }
//}
