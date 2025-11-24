//
//  TransactionService.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-11-01.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class TransactionService: ObservableObject {
    
    static let shared = TransactionService()
    
    @Published var transactions: [Transaction] = []
    
    private let db = Firestore.firestore()
    
    // Add Transaction
    func addTransaction(amount: Double, type: String, category: String, date: Date, note: String, completion: @escaping (Result<Transaction, Error>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return completion(.failure(SimpleError("No user logged in")))
        }
        
        let transaction = Transaction(
            userId: userId,
            amount: amount,
            type: type,
            category: category,
            date: date,
            note: note
        )
        
        do {
            try db.collection("transactions").addDocument(from: transaction) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return completion(.failure(error))
                }
                
                self.fetchTransactions { _ in }
                
                completion(.success(transaction))
            }
        } catch {
            completion(.failure(SimpleError("Unable to save transaction")))
        }
    }
    
    // Fetch Transactions
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return completion(.failure(SimpleError("No user logged in")))
        }
        
        db.collection("transactions")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let documents = snapshot?.documents else {
                    return completion(.success([]))
                }
                
                do {
                    let transactions = try documents.compactMap { doc in
                        try doc.data(as: Transaction.self)
                    }
                    
                    let sortedTransactions = transactions.sorted { $0.date > $1.date }
                    
                    DispatchQueue.main.async {
                        self.transactions = sortedTransactions
                    }
                    
                    completion(.success(sortedTransactions))
                    
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // Update Transaction
    func updateTransaction(transactionId: String, amount: Double, type: String, category: String, date: Date, note: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return completion(.failure(SimpleError("No user logged in")))
        }
        
        let data: [String: Any] = [
            "userId": userId,
            "amount": amount,
            "type": type,
            "category": category,
            "date": Timestamp(date: date),
            "note": note
        ]
        
        db.collection("transactions").document(transactionId).updateData(data) { error in
            if let error = error {
                return completion(.failure(error))
            } else {
                self.fetchTransactions { _ in
                    completion(.success(()))
                }
            }
        }
    }
    
    // Delete Transaction
    func deleteTransaction(transactionId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        db.collection("transactions").document(transactionId).delete { error in
            if let error = error {
                return completion(.failure(error))
            } else {
                self.fetchTransactions { _ in
                    completion(.success(()))
                }
            }
        }
    }
}
