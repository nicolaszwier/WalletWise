//
//  AppConstants.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation

struct Constants {
    
    struct ApiConstants {
        static let apiBaseUrl = "http://localhost:3000/api"
        
        struct Auth {
            static let signin = "/auth/signin"
            static let signup = "/auth/signup"
        }
        
        struct Periods {
            static let getPeriods = "/periods/{{planningId}}"
        }
        
        struct Transactions {
            static let getTransactions = "/transactions/{{periodId}}"
            static let postTransactions = "/transactions"
            static let putTransactions = "/transactions/{{transactionId}}"
            static let deleteTransactions = "/transactions/{{periodId}}/{{transactionId}}"
        }
        
        struct Plannings {
            static let getPlannings = "/plannings"
            static let postPlannings = "/plannings"
            static let putPlannings = "/plannings/{{planningId}}"
            static let deletePlannings = "/plannings/{{planningId}}"
        }
    }
}
