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
            static let postTransaction = "/transactions"
            static let putTransaction = "/transactions/{{transactionId}}"
            static let deleteTransaction = "/transactions/{{periodId}}/{{transactionId}}"
            static let payTransaction = "/transactions/pay/{{periodId}}/{{transactionId}}"
        }
        
        struct Plannings {
            static let getPlannings = "/plannings"
            static let postPlanning = "/plannings"
            static let putPlanning = "/plannings/{{planningId}}"
            static let deletePlanning = "/plannings/{{planningId}}"
        }
        
        struct Users {
            static let getProfile = "/users/my-profile"
        }
        
        struct Api {
            static let status = "/users/status"
        }
    }
}
