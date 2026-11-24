//
//  StockListView.swift
//  StockApp
//
//  View: HANYA urusan tampilan. Tidak ada network call langsung di sini —
//  semua diambil lewat ViewModel.
//

import SwiftUI

struct StockListView: View {

    // 1. State object -> ViewModel yang "hidup" selama View ini ada
    @StateObject private var viewModel = StockListViewModel()

    // Contoh symbol yang mau ditampilkan
    private let watchedSymbols = ["AAPL", "TSLA", "GOOGL"]

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Stock Watchlist")
                .task {
                    await viewModel.loadStocks(symbols: watchedSymbols)
                }
        }
    }

    // 2. Memecah body jadi computed property -> lebih rapi & reusable
    @ViewBuilder
    private var content: some View {
        // Full-screen loading HANYA saat pertama kali buka (belum ada data sama sekali)
        if viewModel.isLoading && viewModel.stocks.isEmpty {
            ProgressView("Memuat data...")
        } else {
            // List selalu ada begitu sudah pernah punya data,
            // supaya .refreshable tidak "diputus paksa" saat refresh berikutnya
            List {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                ForEach(viewModel.stocks) { stock in
                    NavigationLink(destination: StockDetailView(stock: stock)) {
                        StockRowView(stock: stock)
                    }
                }
            }
            .refreshable {
                await viewModel.loadStocks(symbols: watchedSymbols)
            }
        }
    }
}

// 3. Sub-view terpisah untuk satu baris -> reusable & gampang di-test
struct StockRowView: View {
    let stock: Stock

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.headline)
                Text(stock.companyName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("$\(stock.currentPrice, specifier: "%.2f")")
                    .font(.headline)
                Text("\(stock.changePercent, specifier: "%.2f")%")
                    .font(.caption)
                    .foregroundColor(stock.isGaining ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StockListView()
}
