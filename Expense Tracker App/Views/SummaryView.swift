//
//  SummaryView.swift
//  Expense Tracker App
//
//  Created by Rafat on 2025-11-09.
//

import SwiftUI

struct SummaryView: View {
    
    @StateObject private var transactionService = TransactionService.shared
    @State private var selectedFilter = "All Time"
    @State private var isLoaded = false
    @State private var errorMessage: String?
    
    let filterOptions = ["All Time", "This Month", "Last Month", "This Year"]
    
    var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        
        if selectedFilter == "All Time" {
            return transactionService.transactions
        } else if selectedFilter == "This Month" {
            var filtered: [Transaction] = []
            for t in transactionService.transactions {
                if calendar.isDate(t.date, equalTo: now, toGranularity: .month) {
                    filtered.append(t)
                }
            }
            return filtered
        } else if selectedFilter == "Last Month" {
            var filtered: [Transaction] = []
            if let last = calendar.date(byAdding: .month, value: -1, to: now) {
                for t in transactionService.transactions {
                    if calendar.isDate(t.date, equalTo: last, toGranularity: .month) {
                        filtered.append(t)
                    }
                }
            }
            return filtered
        } else if selectedFilter == "This Year" {
            var filtered: [Transaction] = []
            for t in transactionService.transactions {
                if calendar.isDate(t.date, equalTo: now, toGranularity: .year) {
                    filtered.append(t)
                }
            }
            return filtered
        }
        
        return transactionService.transactions
    }
    
    var totalIncome: Double {
        var total = 0.0
        for t in filteredTransactions {
            if t.type == "INCOME" {
                total += t.amount
            }
        }
        return total
    }
    
    var totalExpense: Double {
        var total = 0.0
        for t in filteredTransactions {
            if t.type == "EXPENSE" {
                total += t.amount
            }
        }
        return total
    }
    
    var balance: Double {
        totalIncome - totalExpense
    }
    
    var incomeCount: Int {
        var count = 0
        for t in filteredTransactions {
            if t.type == "INCOME" {
                count += 1
            }
        }
        return count
    }
    
    var expenseCount: Int {
        var count = 0
        for t in filteredTransactions {
            if t.type == "EXPENSE" {
                count += 1
            }
        }
        return count
    }
    
    var expenseCategories: [String] {
        var cat: [String] = []
        for t in filteredTransactions {
            if t.type == "EXPENSE" && !cat.contains(t.category) {
                cat.append(t.category)
            }
        }
        return cat
    }
    
    var incomeCategories: [String] {
        var cat: [String] = []
        for t in filteredTransactions {
            if t.type == "INCOME" && !cat.contains(t.category) {
                cat.append(t.category)
            }
        }
        return cat
    }
    
    func expenseAmount(_ cat: String) -> Double {
        var total = 0.0
        for t in filteredTransactions {
            if t.type == "EXPENSE" && t.category == cat {
                total += t.amount
            }
        }
        return total
    }
    
    func incomeAmount(_ cat: String) -> Double {
        var total = 0.0
        for t in filteredTransactions {
            if t.type == "INCOME" && t.category == cat {
                total += t.amount
            }
        }
        return total
    }
    
    func sortedExpense() -> [String] {
        var cat = expenseCategories
        for i in 0..<cat.count {
            for j in (i + 1)..<cat.count {
                if expenseAmount(cat[j]) > expenseAmount(cat[i]) {
                    let temp = cat[i]
                    cat[i] = cat[j]
                    cat[j] = temp
                }
            }
        }
        return cat
    }
    
    func sortedIncome() -> [String] {
        var cat = incomeCategories
        for i in 0..<cat.count {
            for j in (i + 1)..<cat.count {
                if incomeAmount(cat[j]) > incomeAmount(cat[i]) {
                    let temp = cat[i]
                    cat[i] = cat[j]
                    cat[j] = temp
                }
            }
        }
        return cat
    }
    
    var body: some View {
        Group {
            if !isLoaded {
                ProgressView().onAppear { loadData() }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Picker("Time Period", selection: $selectedFilter) {
                            ForEach(filterOptions, id: \.self) { f in
                                Text(f)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                                VStack(alignment: .leading) {
                                    Text("Total Income")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    
                                    Text("$\(totalIncome, specifier: "%.2f")")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                                VStack(alignment: .leading) {
                                    Text("Total Expenses")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    
                                    Text("$\(totalExpense, specifier: "%.2f")")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                                VStack(alignment: .leading) {
                                    Text("Net Balance")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    
                                    Text("$\(balance, specifier: "%.2f")")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(balance >= 0 ? Color.blue : Color.orange)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        if !expenseCategories.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Expenses by Category")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 10) {
                                    ForEach(sortedExpense(), id: \.self) { cat in
                                        let amount = expenseAmount(cat)
                                        let percent = totalExpense > 0 ? (amount / totalExpense) * 100 : 0
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text(cat)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                
                                                Spacer()
                                                
                                                VStack(alignment: .trailing) {
                                                    Text("$\(amount, specifier: "%.2f")")
                                                        .foregroundColor(.red)
                                                        .font(.headline)
                                                    
                                                    Text("\(percent, specifier: "%.1f")%")
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                                }
                                            }
                                            
                                            GeometryReader { g in
                                                ZStack(alignment: .leading) {
                                                    Rectangle()
                                                        .fill(Color.gray.opacity(0.2))
                                                        .frame(height: 8)
                                                        .cornerRadius(4)
                                                    
                                                    Rectangle()
                                                        .fill(Color.red)
                                                        .frame(width: g.size.width * (percent / 100), height: 8)
                                                        .cornerRadius(4)
                                                }
                                            }
                                            .frame(height: 8)
                                        }
                                        .padding(.vertical, 5)
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        if !incomeCategories.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Income by Category")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 10) {
                                    ForEach(sortedIncome(), id: \.self) { cat in
                                        let amount = incomeAmount(cat)
                                        let percent = totalIncome > 0 ? (amount / totalIncome) * 100 : 0
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text(cat)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                
                                                Spacer()
                                                
                                                VStack(alignment: .trailing) {
                                                    Text("$\(amount, specifier: "%.2f")")
                                                        .foregroundColor(.green)
                                                        .font(.headline)
                                                    
                                                    Text("\(percent, specifier: "%.1f")%")
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                                }
                                            }
                                            
                                            GeometryReader { g in
                                                ZStack(alignment: .leading) {
                                                    Rectangle()
                                                        .fill(Color.gray.opacity(0.2))
                                                        .frame(height: 8)
                                                        .cornerRadius(4)
                                                    
                                                    Rectangle()
                                                        .fill(Color.green)
                                                        .frame(width: g.size.width * (percent / 100), height: 8)
                                                        .cornerRadius(4)
                                                }
                                            }
                                            .frame(height: 8)
                                        }
                                        .padding(.vertical, 5)
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        VStack(spacing: 10) {
                            HStack {
                                Text("Total Transactions")
                                    .font(.headline)
                                Spacer()
                                Text("\(filteredTransactions.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
                            Divider()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Income Entries")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                    
                                    Text("\(incomeCount)")
                                        .font(.title3)
                                        .foregroundColor(.green)
                                        .fontWeight(.semibold)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Expense Entries")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                    
                                    Text("\(expenseCount)")
                                        .font(.title3)
                                        .foregroundColor(.red)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        if filteredTransactions.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                Text("No transactions for this period")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                Text("Try selecting a different time period")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            if let e = errorMessage {
                Text(e)
            }
        }
    }
    
    func loadData() {
        transactionService.fetchTransactions { r in
            switch r {
            case .success:
                isLoaded = true
                errorMessage = nil
            case .failure(let e):
                isLoaded = true
                errorMessage = e.localizedDescription
            }
        }
    }
}

#Preview {
    SummaryView()
}

