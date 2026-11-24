//
//  PortfolioItem.swift
//  StockApp
//
//  Model: merepresentasikan saham yang dimiliki user (bukan sekadar watchlist).
//

import Foundation

struct PortfolioItem: Identifiable, Codable {
    let id: UUID
    let stockSymbol: String
    var quantity: Int
    var averageBuyPrice: Double

    init(
        id: UUID = UUID(),
        stockSymbol: String,
        quantity: Int,
        averageBuyPrice: Double
    ) {
        self.id = id
        self.stockSymbol = stockSymbol
        self.quantity = quantity
        self.averageBuyPrice = averageBuyPrice
    }

    func totalInvested() -> Double {
        return Double(quantity) * averageBuyPrice
    }

    func currentValue(currentPrice: Double) -> Double {
        return Double(quantity) * currentPrice
    }

    func profitOrLoss(currentPrice: Double) -> Double {
        return currentValue(currentPrice: currentPrice) - totalInvested()
    }
}
