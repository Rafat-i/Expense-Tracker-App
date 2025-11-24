//
//  DashboardView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-10-31.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject private var auth = AuthService.shared
    @StateObject private var transactionService = TransactionService.shared
    
    @State private var isLoaded = false
    @State private var errorMessage: String?
    @State private var selectedCategory = "All"
    
    var categories: [String] {
        var set: [String] = ["All"]
        for t in transactionService.transactions {
            if !set.contains(t.category) {
                set.append(t.category)
            }
        }
        return set
    }
    
    var filteredTransactions: [Transaction] {
        if selectedCategory == "All" {
            return transactionService.transactions
        }
        var list: [Transaction] = []
        for t in transactionService.transactions {
            if t.category == selectedCategory {
                list.append(t)
            }
        }
        return list
    }
    
    var totalIncome: Double {
        var total = 0.0
        for t in transactionService.transactions {
            if t.type == "INCOME" {
                total += t.amount
            }
        }
        return total
    }

    var totalExpense: Double {
        var total = 0.0
        for t in transactionService.transactions {
            if t.type == "EXPENSE" {
                total += t.amount
            }
        }
        return total
    }
    
    var balance: Double {
        totalIncome - totalExpense
    }
    
    var body: some View {
        Group {
            if !isLoaded {
                ProgressView().onAppear { loadData() }
            } else {
                ZStack(alignment: .bottomTrailing) {
                    
                    List {
                        VStack(spacing: 20) {
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Welcome,")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text(auth.currentUser?.username ?? "User")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .fontDesign(.rounded)
                                }
                                Spacer()
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(.blue.gradient)
                                    .shadow(radius: 3)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            
                            VStack(spacing: 12) {
                                Text("Total Balance")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Text("$\(balance, specifier: "%.2f")")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(balance >= 0 ? .green : .red)
                                
                                HStack(spacing: 30) {
                                    VStack(spacing: 2) {
                                        Text("Income")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("$\(totalIncome, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack(spacing: 2) {
                                        Text("Expenses")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("$\(totalExpense, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(18)
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
                            .padding(.horizontal)
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(categories, id: \.self) { cat in
                                        Text(cat)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedCategory == cat ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(selectedCategory == cat ? .white : .black)
                                            .cornerRadius(20)
                                            .onTapGesture { selectedCategory = cat }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            if filteredTransactions.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                    Text("No transactions")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 10)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        
                        if !filteredTransactions.isEmpty {
                            ForEach(filteredTransactions) { t in
                                NavigationLink(destination: UpdateTransactionView(transaction: t)) {
                                    TransactionRow(transaction: t)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteAtOffsets)
                        }
                        
                        if let msg = errorMessage {
                            Text(msg)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    NavigationLink(destination: AddTransactionView()) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 58, height: 58)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 3)
                            .padding()
                    }
                }
            }
        }
    }
    
    func loadData() {
        transactionService.fetchTransactions { r in
            switch r {
            case .success: isLoaded = true; errorMessage = nil
            case .failure(let e): isLoaded = true; errorMessage = e.localizedDescription
            }
        }
    }
    
    func deleteAtOffsets(at offsets: IndexSet) {
        for index in offsets {
            let t = filteredTransactions[index]
            if let id = t.id {
                transactionService.deleteTransaction(transactionId: id) { r in
                    switch r {
                    case .success:
                        errorMessage = nil
                        loadData()
                    case .failure(let e):
                        errorMessage = e.localizedDescription
                    }
                }
            } else {
                errorMessage = "Cannot delete transaction"
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
            .padding(.horizontal, 12)
        }
        
        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    }
}

#Preview {
    DashboardView()
}
