//
//  LocationTests.swift
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

class LocationTests: QuickSpec {
    let disposeBag = DisposeBag()
    
    override func spec() {
        describe(".isMeintenance") {
            var result:Bool?
            beforeEach { result = nil }
            
            let from = (hour:3,minute:0)
            let to = (hour:5,minute:0)
            if Date.inRange(from:from , to: to) {
                context("when system is meintenance") {
                    it("is true"){
                        API.Location.isMeintenance().subscribe(onNext: { isMeintenance in
                            result = isMeintenance
                        }, onError: nil)
                            .addDisposableTo(self.disposeBag)
                        expect(result).toEventually(equal(true), timeout: 5)
                    }
                }
            }else{
                context("when system is not meintenance") {
                    it("is false"){
                        API.Location.isMeintenance().subscribe(onNext: { isMeintenance in
                            result = isMeintenance
                        }, onError: nil)
                            .addDisposableTo(self.disposeBag)
                        expect(result).toEventually(equal(false), timeout: 5)
                    }
                }
            }
        }
    }
}

