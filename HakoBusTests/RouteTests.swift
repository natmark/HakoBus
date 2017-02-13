//
//  RouteTests.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import XCTest
import RxSwift
import ObjectMapper

@testable import HakoBus

class RouteTests: XCTestCase {
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
        var routeSearchRequestParameters:RouteSearchRequestParameters? = nil
        
        routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":1,\"destination\":2}")! // 函館バスセンター→松風町
        API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
            XCTAssertTrue(isExistRoute)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":3,\"destination\":165}")! // 函館駅前→はこだて未来大学
        API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
            XCTAssertTrue(isExistRoute)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":155,\"destination\":165}")! // 亀田支所前→はこだて未来大学
        API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
            XCTAssertTrue(isExistRoute)
        }, onError: nil)
            .addDisposableTo(disposeBag)
        
        routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":3,\"destination\":3}")! // 函館駅→函館駅
        API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
            XCTAssertFalse(isExistRoute)
        }, onError: nil)
            .addDisposableTo(disposeBag)

        routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":3,\"destination\":0}")! // 函館駅→存在しないバス停
        API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
            XCTAssertFalse(isExistRoute)
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
