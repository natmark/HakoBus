//
//  Location.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/12.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

extension Router {
    enum Location: URLRequestConvertible {

        case isMeintenance()
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .isMeintenance:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .isMeintenance:
                return "search01.php"
            }
        }
        
        public func asURLRequest() throws -> URLRequest {
            let URL = NSURL(string: "http://www.hakobus.jp/")!
            var request = URLRequest(url: URL.appendingPathComponent(self.path)!)
            request.httpMethod = self.method.rawValue
            
            switch self {
            case .isMeintenance:
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:[:])
            }
        }
    }
}
extension API {
    /// 函館バスロケーションとの通信クラス
    class Location {
        /// バスロケサイトがメンテナンス中かどうかを判定
        /// - returns: メンテ中ならtrue
        static func isMeintenance() -> Observable<Bool> {
            return API.manager.rx.request(urlRequest: Router.Location.isMeintenance())
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString()
                        .flatMap { (res,html) -> Observable<Bool> in
                            return Observable.just(html.contains("只今、システムメンテナンス中のためバス接近情報はご利用できません。"))
                    }
                }
                .observeOn(MainScheduler.instance)
            
        }
    }
}
