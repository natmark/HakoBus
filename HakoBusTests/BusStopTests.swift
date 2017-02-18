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
import Quick
import Nimble
@testable import HakoBus

class BusStopTests: QuickSpec {
    let disposeBag = DisposeBag()
    
    override func spec() {
        describe(".search") {
            var result:BusStopSearchResultParameters?
            var busStopSearchRequestParameters:BusStopSearchRequestParameters?
            beforeEach { result = nil; busStopSearchRequestParameters = nil }

            context("set collect parameter") {
                it("is not nil"){
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"函館\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toNotEventually(beNil(), timeout: 5)
                    
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"はこだて\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toNotEventually(beNil(), timeout: 5)
                    
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"亀田\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toNotEventually(beNil(), timeout: 5)

                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"新函館北斗駅\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toNotEventually(beNil(), timeout: 5)
                    
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"駅\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toNotEventually(beNil(), timeout: 5)
                }
            }
            context("set empty parameter"){
                it("is nil"){
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(beNil(), timeout: 5)
                }
            }
            context("set invalid parameter"){
                it("is nil"){
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"test\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(beNil(), timeout: 5)
                    
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"テスト\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(beNil(), timeout: 5)
                    
                    busStopSearchRequestParameters = Mapper<BusStopSearchRequestParameters>().map(JSONString: "{\"name\":\"新函館駅\"}")!
                    API.BusStop.search(searchParams: busStopSearchRequestParameters!).subscribe(onNext: { busstop in
                        result = busstop
                    }, onError: nil)
                        .addDisposableTo(self.disposeBag)
                    expect(result).toEventually(beNil(), timeout: 5)
                }
            }
        }
    }
}

