//
//  StockListViewModel.swift
//  StockApp
//
//  ViewModel: menyimpan state & logika untuk layar daftar saham.
//  Ini "otak" di antara Model dan View (pola MVVM).
//

import Foundation
import Combine

@MainActor
final class StockListViewModel: ObservableObject {

    // 1. Published properties -> otomatis update View saat berubah
    @Published var stocks: [Stock] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var favoriteSymbols: [String] = [] {
        didSet {
            UserDefaults.standard.set(favoriteSymbols, forKey:
            "favoriteSymbols")
        }
    }

    // 2. Dependency (bisa di-inject untuk testing / mock)
    private let apiService: StockAPIServiceProtocol

    init(apiService: StockAPIServiceProtocol? = nil) {
        self.apiService = apiService ?? StockAPIService()
        favoriteSymbols = UserDefaults.standard.stringArray(forKey:
        "favoriteSymbols") ?? []
    }

    // 3. Fungsi utama: memuat data saham
    func loadStocks(symbols: [String]) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedStocks = try await apiService.fetchStockList(symbols: symbols)

            // Jangan update UI jika task sudah dibatalkan
            guard !Task.isCancelled else {
                isLoading = false
                return
            }

            stocks = fetchedStocks

        } catch {
            // Cek apakah error yang dibungkus APIError ini sebenarnya cancellation
            if let apiError = error as? APIError,
               case .requestFailed(let underlyingError) = apiError,
               (underlyingError as? URLError)?.code == .cancelled {
                isLoading = false
                return
            }

            if error is CancellationError {
                isLoading = false
                return
            }

            errorMessage = "Gagal memuat data saham: \(error.localizedDescription)"
        }

        isLoading = false
    }
    // 4. Fungsi logika tambahan: filter saham yang sedang naik
    func gainingStocks() -> [Stock] {
        return stocks.filter { $0.isGaining }
    }

    // 5. Fungsi logika tambahan: sorting berdasarkan performa
    func sortedByPerformance() -> [Stock] {
        return stocks.sorted { $0.changePercent > $1.changePercent }
    }
    
    var filteredStocks: [Stock] {
        if searchText.isEmpty {
            return stocks
        }
        return stocks.filter {
            $0.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func toggleFavorite(_ symbol: String) {
        if favoriteSymbols.contains(symbol) {
            favoriteSymbols.removeAll { $0 == symbol }
        } else {
            favoriteSymbols.append(symbol)
        }
    }
}
