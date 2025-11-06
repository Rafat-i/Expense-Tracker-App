//
//  AddTransactionView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-11-01.
//

import SwiftUI

struct AddTransactionView: View {
    
    @State private var amount = ""
    @State private var selectedType = "EXPENSE"
    @State private var selectedCategory = "Food"
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
            Section("Transaction Details") {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Type", selection: $selectedType) {
                    ForEach(transactionTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedType) {
                    if selectedType == "INCOME" {
                        selectedCategory = incomeCategories[0]
                    } else {
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
                Text("Transaction added successfully!")
                    .foregroundStyle(.green)
            }
            
            Button("Save Transaction") {
                saveTransaction()
            }
            .disabled(amount.isEmpty)
        }
        .navigationTitle("Add Transaction")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            errorMessage = "Please enter a valid amount"
            return
        }
        
        transactionService.addTransaction(
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
                
                amount = ""
                note = ""
                selectedDate = Date()
                
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
        AddTransactionView()
    }
}
