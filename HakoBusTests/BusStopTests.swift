//
//  BusStopTests.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import XCTest
import RxSwift
import ObjectMapper

@testable import HakoBus

class BusStopTests: XCTestCase {
    let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var busStopSearchRequestParameters:BusStopSearchRequestParameters? = nil
        
        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"函館\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNotNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)
        
        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"はこだて\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNotNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"亀田\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNotNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"新函館北斗駅\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNotNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"駅\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNotNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"test\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"テスト\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"新函館駅\"}")!
        API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
            XCTAssertNil(busstop)
        }, onError: nil)
            .addDisposableTo(disposeBag)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
