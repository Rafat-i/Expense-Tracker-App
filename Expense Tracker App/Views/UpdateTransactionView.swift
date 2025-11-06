//
//  UpdateTransactionView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-11-03.
//

import SwiftUI

struct UpdateTransactionView: View {
    
    let transaction: Transaction
    
    @State private var amount = ""
    @State private var selectedType = ""
    @State private var selectedCategory = ""
    @State private var selectedDate = Date()
    @State private var note = ""
    @State private var errorMessage: String?
    @State private var showSuccess = false
    
    @StateObject private var transactionService = TransactionService.shared
    
    @Environment(\.dismiss) var dismiss
    
    let transactionTypes = ["INCOME", "EXPENSE"]
    
    let incomeCategories = ["Salary", "Return of Investments", "Other"]
    let expenseCategories = ["Rent", "Transport", "Food", "Entertainment", "Shopping", "Bills", "Other"]
    
    var availableCategories: [String] {
        selectedType == "INCOME" ? incomeCategories : expenseCategories
    }
    
    var body: some View {
        Form {
            Section("Edit Transaction") {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Type", selection: $selectedType) {
                    ForEach(transactionTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedType) {
                    if selectedType == "INCOME" && !incomeCategories.contains(selectedCategory) {
                        selectedCategory = incomeCategories[0]
                    } else if selectedType == "EXPENSE" && !expenseCategories.contains(selectedCategory) {
                        selectedCategory = expenseCategories[0]
                    }
                }
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(availableCategories, id: \.self) { category in
                        Text(category)
                    }
                }
                
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                
                TextField("Note (optional)", text: $note)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            
            if showSuccess {
                Text("Transaction updated successfully!")
                    .foregroundStyle(.green)
            }
            
            Button("Save Changes") {
                updateTransaction()
            }
            .disabled(amount.isEmpty)
        }
        .navigationTitle("Update Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadTransactionData)
    }
    
    func loadTransactionData() {
        amount = String(transaction.amount)
        selectedType = transaction.type
        selectedCategory = transaction.category
        selectedDate = transaction.date
        note = transaction.note
    }
    
    func updateTransaction() {
        guard let transactionId = transaction.id else {
            errorMessage = "Invalid transaction ID"
            return
        }
        
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Please enter a valid amount"
            return
        }
        
        transactionService.updateTransaction(
            transactionId: transactionId,
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            date: selectedDate,
            note: note
        ) { result in
            switch result {
            case .success:
                errorMessage = nil
                showSuccess = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
                showSuccess = false
            }
        }
    }
}

#Preview {
    NavigationView {
        UpdateTransactionView(transaction: Transaction(
            userId: "demo",
            amount: 50.0,
            type: "EXPENSE",
            category: "Food",
            date: Date(),
            note: "Dinner"
        ))
    }
}

