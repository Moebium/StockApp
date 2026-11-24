//
//  StockAppApp.swift
//  StockApp
//
//  Entry point aplikasi. Ini file "paling atas" -> sederhana,
//  cuma menunjuk ke View utama.
//

import SwiftUI

@main
struct StockAppApp: App {
    var body: some Scene {
        WindowGroup {
            StockListView()
        }
    }
}
