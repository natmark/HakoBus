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
import Quick
import Nimble
@testable import HakoBus

class RouteTests: QuickSpec {
    let disposeBag = DisposeBag()
    
    override func spec() {
        describe(".isExist") {
            var result:Bool?
            var routeSearchRequestParameters:RouteSearchRequestParameters?
            beforeEach { result = nil; routeSearchRequestParameters = nil }
            
            context("set collect parameter") {
                it("is true"){
                    routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":1,\"destination\":2}")! // 函館バスセンター→松風町
                    API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
                        result = isExistRoute
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(equal(true), timeout: 5)

                    
                    routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":3,\"destination\":165}")! // 函館駅前→はこだて未来大学
                    API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
                        result = isExistRoute
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(equal(true), timeout: 5)
                    
                    routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":155,\"destination\":165}")! // 亀田支所前→はこだて未来大学
                    API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
                        result = isExistRoute
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(equal(true), timeout: 5)
                }
            }
             context("set duplicated parameter") {
                  it("is false"){
                    routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":3,\"destination\":3}")! // 函館駅→函館駅
                    API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
                        result = isExistRoute
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(equal(false), timeout: 5)

                }
            }
            context("set invalid parameter") {
                it("is false"){
                    routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":3,\"destination\":0}")! // 函館駅→存在しないバス停
                    API.Route.isExist(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isExistRoute in
                        result = isExistRoute
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(equal(false), timeout: 5)
                }
            }
        }
        describe(".isOutOfService"){
            var result:Bool?
            var routeSearchRequestParameters:RouteSearchRequestParameters?
            beforeEach { result = nil; routeSearchRequestParameters = nil }
            
            context("route search from 亀田支所前 to はこだて未来大学"){
                routeSearchRequestParameters = Mapper<RouteSearchRequestParameters>().map(JSONString: "{\"origin\":155,\"destination\":165}")! // 亀田支所前→はこだて未来大学
                API.Route.isOutOfService(searchParams:routeSearchRequestParameters!).subscribe(onNext: { isOutOfService in
                    result = isOutOfService
                }, onError: nil)
                    .addDisposableTo(self.disposeBag)
                
                if Holiday.isWeekDay() {
                    context("Today is WeekDay"){
                        //平日 8:03 ~ 20:35
                        let from = (hour:8,minute:3)
                        let to = (hour:20,minute:35)
                        
                        if Date.inRange(from: from, to: to) {
                            it("return false"){
                                expect(result).toEventually(equal(false), timeout: 5)
                            }
                        }else{
                            it("return true"){
                                expect(result).toEventually(equal(true), timeout: 5)
                            }
                        }
                    }
                }else {
                    context("Today is Holiday"){
                        //土日祝 7:59 ~ 20:35
                        let from = (hour:7,minute:59)
                        let to = (hour:20,minute:35)
                        
                        if Date.inRange(from: from, to: to) {
                            it("return false"){
                                expect(result).toEventually(equal(false), timeout: 5)
                            }
                        }else{
                            it("return true"){
                                expect(result).toEventually(equal(true), timeout: 5)
                            }
                        }
                    }
                }
            }
        }
    }
}
