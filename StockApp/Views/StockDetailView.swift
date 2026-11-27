//
//  StockDetailView.swift
//  StockApp
//
//  View: menampilkan detail satu saham.
//  Menerima objek Stock dari halaman sebelumnya — tidak fetch data sendiri.
//

import SwiftUI

struct StockDetailView: View {
    let stock: Stock

    var body: some View {
        List {
            // Header: harga besar + perubahan persen
            Section {
                VStack(spacing: 4) {
                    Text("$\(stock.currentPrice, specifier: "%.2f")")
                        .font(.system(size: 40, weight: .bold))

                    Text("\(stock.changePercent >= 0 ? "+" : "")\(stock.changePercent, specifier: "%.2f")% from previous close")
                        .font(.subheadline)
                        .foregroundStyle(stock.isGaining ? .green : .red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            Section("Detail") {
                HStack {
                    Text("Symbol")
                    Spacer()
                    Text(stock.symbol)
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Current price")
                    Spacer()
                    Text("$\(stock.currentPrice, specifier: "%.2f")")
                }
                HStack {
                    Text("Previous close")
                    Spacer()
                    Text("$\(stock.previousClose, specifier: "%.2f")")
                }
            }
        }
        .navigationTitle(stock.symbol)
        .navigationBarTitleDisplayMode(.inline)
    }
}
