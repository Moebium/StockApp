//
//  StockAppTests.swift
//  StockAppTests
//
//  Created by Raihan Aji Kinarya on 27/11/26.
//

import XCTest
@testable import StockApp

final class StockAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
    }
    
    func testChangePercentWhenPreviousCloseIsZero() {
        let stock = Stock(symbol: "TEST", companyName: "Test Inc",
                          currentPrice: 50, previousClose: 0)
        
        XCTAssertEqual(stock.changePercent, 0)
    }
    
    func testChangePercentWhenPriceRises() {
        let stock = Stock(symbol: "TEST", companyName: "Test Inc",
        currentPrice: 110, previousClose: 100)
        
        XCTAssertEqual(stock.changePercent, 10, accuracy: 0.0001)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
