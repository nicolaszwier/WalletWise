//
//  AppConstants.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 30/04/24.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct ApiConstants {
        static let apiBaseUrl = "http://localhost:3000/api"
//        static let apiBaseUrl = "https://ww-prod.up.railway.app/api"
//        static let apiBaseUrl = "https://ww-staging.up.railway.app/api"
    
        
        struct Auth {
            static let signin = "/auth/signin"
            static let signup = "/auth/signup"
        }
        
        struct Periods {
            static let getPeriods = "/periods/{{planningId}}"
        }
        
        struct Transactions {
            static let getTransactions = "/transactions/{{periodId}}"
            static let getPendingTransactionsDueInAWeek = "/transactions/due-this-week/{{planningId}}"
            static let postTransaction = "/transactions"
            static let postManyTransactions = "/transactions/many"
            static let putTransaction = "/transactions/{{transactionId}}"
            static let deleteTransaction = "/transactions/{{periodId}}/{{transactionId}}"
            static let payTransaction = "/transactions/pay/{{periodId}}/{{transactionId}}"
            static let getMonthlyBalance = "/transactions/monthly_balance/{{planningId}}"
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
    
    struct UserDefaults {
        static let token = "token"
        static let selectedPlanning = "selectedPlanning"
        static let welcomeScreenDone = "welcomeScreenDone"
    }
    
    struct UI {
        static let defaultGradient = LinearGradient(colors: [Color.gradientPrimary, Color.gradientSecondary], startPoint: .bottomLeading, endPoint: .topTrailing)
        static let defaultTextGradient = LinearGradient(colors: [Color.gradientTextPrimary, Color.gradientTextSecondary], startPoint: .bottomLeading, endPoint: .topTrailing)
    }
}
