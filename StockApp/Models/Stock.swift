//
//  Stock.swift
//  StockApp
//
//  Model: merepresentasikan satu data saham.
//

import Foundation

struct Stock: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let companyName: String
    var currentPrice: Double
    var previousClose: Double

    init(
        id: UUID = UUID(),
        symbol: String,
        companyName: String,
        currentPrice: Double,
        previousClose: Double
    ) {
        self.id = id
        self.symbol = symbol
        self.companyName = companyName
        self.currentPrice = currentPrice
        self.previousClose = previousClose
    }

    // Computed property: perubahan harga dalam persen
    var changePercent: Double {
        guard previousClose != 0 else { return 0 }
        return ((currentPrice - previousClose) / previousClose) * 100
    }

    var isGaining: Bool {
        return currentPrice >= previousClose
    }
    
    func formattedChangePercent() -> String {
        let formattedNumber = String(format: "%.2f", changePercent)
        let profit: String = "\(formattedNumber)%"
        
        if changePercent >= 0 {
            return "+" + profit
        } else {
            return profit
        }
    }
}

// Extension terpisah untuk mock/testing data
extension Stock {
    static func mockList() -> [Stock] {
        return [
            Stock(symbol: "AAPL", companyName: "Apple Inc.", currentPrice: 191.20, previousClose: 188.50),
            Stock(symbol: "TSLA", companyName: "Tesla Inc.", currentPrice: 245.10, previousClose: 250.00),
            Stock(symbol: "GOOGL", companyName: "Alphabet Inc.", currentPrice: 138.75, previousClose: 137.90)
        ]
    }
}
