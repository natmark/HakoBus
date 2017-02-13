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
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .isExist:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .isExist(_):
                return "result.php"
            }
        }
        
        public func asURLRequest() throws -> URLRequest {
            let URL = NSURL(string: "http://www.hakobus.jp/")!
            var request = URLRequest(url: URL.appendingPathComponent(self.path)!)
            request.httpMethod = self.method.rawValue
            
            switch self {
            case .isExist(let params):
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:params.APIParams)
            }
        }
    }
}

extension API {
    /// ルート検索用クラス
    class Route {
        /// 2点間を結ぶ路線が存在するかどうかを確認
        /// - parameter　searchParams: RouteSearchParams
        /// - returns: 直通する路線があればtrue
        static func isExist(searchParams:RouteSearchRequestParameters) -> Observable<Bool> {
            return API.manager.rx.request(urlRequest: Router.Route.isExist(searchParams))
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString(encoding: String.Encoding.shiftJIS)
                        .flatMap { (res,html) -> Observable<Bool> in
                            return Observable.just(!html.contains("指定された区間の直通便はありません。"))
                    }
                }
                .observeOn(MainScheduler.instance)
        }
    }
}
