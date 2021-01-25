//
//  Enums.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import Foundation

enum Sender {
    case editor
    case creator
}

enum ScannerSheets {
    case scannerIDPass
    case scannerTips
    case scannerBankStatements
    case scannerSalaryPay
    case idPassScan
    case bankStatementsScan
    case salaryPayScan
    case none
}

enum OtherQuestionCheck {
    case both
    case one
    case neither
}
