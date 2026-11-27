//
//  StockAPIService.swift
//  StockApp
//
//  Networking: bertanggung jawab HANYA untuk komunikasi dengan API luar.
//  Tidak boleh ada logic UI di sini — pisahkan urusan (separation of concerns).
//

import Foundation

enum APIError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key tidak ditemukan. Periksa Secrets.xcconfig dan Info.plist."

        case .invalidURL:
            return "URL API tidak valid."

        case .requestFailed(let error):
            return "Koneksi gagal: \(error.localizedDescription)"

        case .invalidResponse(let statusCode):
            return "Server Finnhub merespons dengan status code \(statusCode)."

        case .decodingFailed(let error):
            return "Format data dari Finnhub tidak sesuai: \(error.localizedDescription)"
        }
    }
}

// Respons JSON asli dari endpoint /quote Finnhub
private struct FinnhubQuote: Codable {
    let c: Double    // current price
    let pc: Double   // previous close
}

private struct FinnhubProfile: Codable {
    let name: String
}

protocol StockAPIServiceProtocol {
    func fetchStock(symbol: String) async throws -> Stock
    func fetchStockList(symbols: [String]) async throws -> [Stock]
}

final class StockAPIService: StockAPIServiceProtocol {

    // API key dibaca dari Info.plist (diisi otomatis dari Secrets.xcconfig saat build)
    private var apiKey: String {
        Bundle.main.infoDictionary?["FINNHUB_API_KEY"] as? String ?? ""
    }
    
    private func fetchCompanyName(symbol: String) async -> String {
        var components = URLComponents(string:
        "https://finnhub.io/api/v1/stock/profile2")
        components?.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "token", value: apiKey)
        ]
        
        guard let url = components?.url else { return symbol }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let profile = try JSONDecoder().decode(FinnhubProfile.self, from:
            data)
            
            return profile.name
        } catch {
            return symbol
        }
    }

    func fetchStock(symbol: String) async throws -> Stock {
        // 1. Pastikan API key tersedia
        guard !apiKey.isEmpty else {
            throw APIError.missingAPIKey
        }

        // 2. Bangun URL dengan URLComponents
        var components = URLComponents(string: "https://finnhub.io/api/v1/quote")
        components?.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "token", value: apiKey)
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        // 3. Kirim request — hanya error jaringan yang dibungkus requestFailed
        let (data, response): (Data, URLResponse)

        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw APIError.requestFailed(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: -1)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        // 4. Decode respons Finnhub, lalu petakan ke model Stock kita
        do {
            let quote = try JSONDecoder().decode(FinnhubQuote.self, from: data)
            let name = await fetchCompanyName(symbol: symbol)
            return Stock(
                symbol: symbol,
                companyName: name,
                currentPrice: quote.c,
                previousClose: quote.pc
            )
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    func fetchStockList(symbols: [String]) async throws -> [Stock] {
        // Fetch paralel pakai TaskGroup, jauh lebih efisien daripada loop satu-satu
        try await withThrowingTaskGroup(of: Stock.self) { group in
            for symbol in symbols {
                group.addTask {
                    try await self.fetchStock(symbol: symbol)
                }
            }

            var results: [Stock] = []
            for try await stock in group {
                results.append(stock)
            }
            return results
        }
    }
}
