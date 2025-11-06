//
//  TransactionListView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-11-01.
//

import SwiftUI

struct TransactionListView: View {
    
    @StateObject private var transactionService = TransactionService.shared
    @State private var isLoaded = false
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if !isLoaded {
                ProgressView()
                    .onAppear {
                        loadTransactions()
                    }
            } else if transactionService.transactions.isEmpty {
                VStack {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No transactions yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Add your first transaction!")
                        .foregroundColor(.gray)
                }
            } else {
                List {
                    ForEach(transactionService.transactions) { transaction in
                        NavigationLink(destination: UpdateTransactionView(transaction: transaction)) {
                            TransactionRow(transaction: transaction)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteTransaction(transaction)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .refreshable {
                    loadTransactions()
                }
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    func loadTransactions() {
        transactionService.fetchTransactions { result in
            switch result {
            case .success:
                isLoaded = true
                errorMessage = nil
            case .failure(let error):
                isLoaded = true
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        guard let transactionId = transaction.id else {
            errorMessage = "Cannot delete transaction"
            return
        }
        
        transactionService.deleteTransaction(transactionId: transactionId) { result in
            switch result {
            case .success:
                errorMessage = nil
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(transaction.category)
                    .font(.headline)
                
                Text(transaction.note.isEmpty ? "No note" : transaction.note)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(formattedDate(transaction.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(transaction.type)
                    .font(.caption)
                    .foregroundColor(transaction.type == "INCOME" ? .green : .red)
                
                Text("$\(transaction.amount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(transaction.type == "INCOME" ? .green : .red)
            }
        }
        .padding(.vertical, 5)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        TransactionListView()
    }
}
