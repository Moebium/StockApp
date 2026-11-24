// xcode: set sdk=iOS

//
//  NumberFormatter+Extensions.swift
//  StockApp
//
//  Utilities: fungsi bantu kecil yang dipakai di banyak tempat.
//  Taruh di sini biar tidak duplikasi logic yang sama di banyak View/ViewModel.
//

import Foundation

extension Double {
    /// Format angka jadi mata uang, contoh: 1234.5 -> "$1,234.50"
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }

    /// Format angka jadi persen, contoh: 3.456 -> "+3.46%"
    func asPercentChange() -> String {
        let sign = self >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", self))%"
    }
}
