//
//  TimelineViewViewModel.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 02/05/24.
//

import Foundation
import SwiftUI

@MainActor
class TransactionsViewViewModel: ObservableObject {
    @Published var periods: [Period] = []
    @Published var isLoading: Bool = false
    @Published var isPresentingNewTransactionView = false
    @Published var isPresentingEditTransactionView = false
    @Published var isPresentingFiltersView = false
    @Published var errorMessage = ""
    @Published var newTransaction = Transaction(id: "", periodId: "", planningId: "", userId: "", amount: 0)
    @Published var formErrors: [String] = []
       
    func fetch(planning: Planning) async {
        do {
            let response = try await TimelineModel().fetch(planningId: planning.id)
            DispatchQueue.main.async {
                self.periods = response
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("Error fetching data: \(error)")
                self.isLoading = false;
            }
        }

    }
    
    func saveNewTransaction(planningId: String) async  {
        guard isFormValid(transaction: self.newTransaction) else {
            print("form invalid", formErrors.count)
            return
        }
        self.isLoading = true;
        do {
            self.newTransaction.planningId = planningId
            _ = try await TransactionModel().save(transaction: self.newTransaction)
                DispatchQueue.main.async {
                    print("success")
                    self.isLoading = false;
                }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.isLoading = false;
                self.errorMessage = "Error on submitting transaction"
            }
        }
    }
    
    func updateTransaction(transaction: Transaction) async  {
        guard isFormValid(transaction: transaction) else {
            print("form invalid", formErrors.count)
            return
        }
        self.isLoading = true;
        do {
            _ = try await TransactionModel().update(transaction: transaction)
                DispatchQueue.main.async {
                    print("success")
                    self.isLoading = false;
                }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.isLoading = false;
                self.errorMessage = "Error on updating transaction"
            }
        }
    }
    
    func payTransaction(transaction: Transaction) async  {
        self.isLoading = true;
        do {
            _ = try await TransactionModel().pay(periodId: transaction.periodId ?? "", transactionId: transaction.id ?? "")
            DispatchQueue.main.async {
                    print("success")
                    self.isLoading = false;
                }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.isLoading = false;
                self.errorMessage = "Error on paying"
            }
        }
    }
    
    private func isFormValid(transaction: Transaction) -> Bool {
            self.formErrors.removeAll()
            guard !transaction.amount.isLessThanOrEqualTo(0) else {
                self.formErrors.append("Amount should be more than zero.")
                return false
            }
            
            guard !transaction.description.trimmingCharacters(in: .whitespaces).isEmpty else {
                self.formErrors.append("Description should not be empty.")
                return false
            }
        
        return true
    }
    
    func removeTransaction(periodId: String, transactionId: String) async  {
        do {
            _ = try await TransactionModel().remove(periodId: periodId, transactionId: transactionId)
                DispatchQueue.main.async {
                    print("success")
//                    self.isLoading = false;
                }
        } catch {
            DispatchQueue.main.async {
                print("Error: \(error)")
                self.isLoading = false;
//                self.errorMessage = "Error on removing transaction"
            }
        }
    }
    
    
    func formattedDate(date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM d"
           return dateFormatter.string(from: date)
    }
    
    func formatCurrency(amount: Decimal) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            
            return formatter.string(from: amount as NSDecimalNumber) ?? ""
    }
}
