//
//  TransactionModel.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import Foundation
import FirebaseFirestore

struct Transaction: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var amount: Double
    var type: String // "INCOME" or "EXPENSE"
    var category: String
    var date: Date
    var note: String
}
