//
//  Route.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

extension Router {
    enum Route: URLRequestConvertible {
        
        case isExist(RouteSearchRequestParameters)
        case isOutOfService(RouteSearchRequestParameters)
        case search(RouteSearchRequestParameters)
        case getArrivedSchedule(String)
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .isExist:
                return .get
            case .isOutOfService:
                return .get
            case .search:
                return .get
            case .getArrivedSchedule:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .isExist(_):
                return "result.php"
            case .isOutOfService(_):
                return "result.php"
            case .search(_):
                return "result.php"
            case .getArrivedSchedule(let schedule_url):
                return schedule_url
            }
        }
        
        public func asURLRequest() throws -> URLRequest {
            let URL = NSURL(string: "http://www.hakobus.jp/")!
            var request = URLRequest(url: URL.appendingPathComponent(self.path)!)
            request.httpMethod = self.method.rawValue
            
            switch self {
            case .isExist(let params):
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:params.APIParams)
            case .isOutOfService(let params):
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:params.APIParams)
            case .search(let params):
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:params.APIParams)
            case .getArrivedSchedule(_):
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:[:])
            }
        }
    }
}

extension API {
    /// ルート検索用クラス
    class Route {
        /// 2点間を結ぶ路線が存在するかどうかを確認
        /// - parameter　searchParams: RouteSearchRequestParameters
        /// - returns: 直通する路線があればtrue
        static func isExist(searchParams:RouteSearchRequestParameters) -> Observable<Bool> {
            return API.manager.rx.request(urlRequest: Router.Route.isExist(searchParams))
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString(encoding: String.Encoding.shiftJIS)
                        .flatMap { (res,html) -> Observable<Bool> in
                            return Observable.just(!(html.contains("指定された区間の直通便はありません。") || html.contains("乗車停留所と降車停留所に同じ停留所が選択されています。")))
                    }
                }
                .observeOn(MainScheduler.instance)
        }
        /// 2点間を結ぶ路線が営業時間外かどうかを確認
        /// - parameter　searchParams: RouteSearchRequestParameters
        /// - returns: 営業時間外であればtrue
        static func isOutOfService(searchParams:RouteSearchRequestParameters) -> Observable<Bool> {
            return API.manager.rx.request(urlRequest: Router.Route.isOutOfService(searchParams))
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString(encoding: String.Encoding.shiftJIS)
                        .flatMap { (res,html) -> Observable<Bool> in
                            return Observable.just(html.contains("本日の運行は終了しました。"))
                    }
                }
                .observeOn(MainScheduler.instance)
        }
        /// 乗り場・降り場を指定してルート検索
        /// - parameter　searchParams: RouteSearchRequestParameters
        /// - returns: 営業時間外であればtrue
        static func search(searchParams:RouteSearchRequestParameters) -> Observable<RouteSearchResultParameters> {
            return API.manager.rx.request(urlRequest: Router.Route.search(searchParams))
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString(encoding: String.Encoding.shiftJIS)
                        .flatMap { (res,html) -> Observable<RouteSearchResultParameters> in
                           //Kannaで抜き出して return
                            let results = [RouteSearchResultParameters]()
                            return Observable.from(results)
                    }
                }
                .observeOn(MainScheduler.instance)
        }
        /// URLを指定して各地点の到着時刻を取得
        /// - parameter　searchParams: RouteSearchParams
        /// - returns: 営業時間外であればtrue
        static func getArrivedSchedule(schedule_url:String) -> Observable<ArrivedScheduleResultParameters> {
            return API.manager.rx.request(urlRequest: Router.Route.getArrivedSchedule(schedule_url))
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString(encoding: String.Encoding.shiftJIS)
                        .flatMap { (res,html) -> Observable<ArrivedScheduleResultParameters> in
                            //Kannaで抜き出して return
                            let results = [ArrivedScheduleResultParameters]()
                            return Observable.from(results)
                    }
                }
                .observeOn(MainScheduler.instance)
        }
    }
}
