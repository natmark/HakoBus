//
//  BusStop.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/13.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper
import Kanna

extension Router {
    enum BusStop: URLRequestConvertible {
        case search(BusStopSearchRequestParameters)
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .search:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .search(_):
                return "search02.php"
            }
        }
        
        public func asURLRequest() throws -> URLRequest {
            let URL = NSURL(string: "http://www.hakobus.jp/")!
            var request = URLRequest(url: URL.appendingPathComponent(self.path)!)
            request.httpMethod = self.method.rawValue
            switch self {
            case .search(let params):
                return try Alamofire.URLEncoding.default.encode(request as URLRequestConvertible, with:params.APIParams)
            }
        }
        
        /// バス停検索用エンコーダ
        /// リクエストパラメータをShift-JISでエンコードする
        struct BusStopSearchEncoding: ParameterEncoding {
            func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
                var request = try! URLEncoding().encode(urlRequest, with: parameters)
                let urlString = "\((urlRequest.urlRequest?.url?.absoluteString)!)?stopname_f=\(((parameters?.first?.value)! as! String).sjisPercentEncoded)&stopname_t="
                request.url = URL(string: urlString)
                return request
            }
        }
    }
}
extension API {
    /// バス停検索用クラス
    class BusStop {
        /// バス停名を指定してバス停検索
        /// - parameter　searchParams: RouteSearchRequestParameters
        /// - returns: BusStopSearchResultParameters
        
        static func search(searchParams:BusStopSearchRequestParameters) -> Observable<BusStopSearchResultParameters> {
            
            // パラメータをShift-JISでエンコーディングする必要がある
            return API.manager.rx.request(Router.BusStop.search(searchParams).method, (Router.BusStop.search(searchParams).urlRequest?.url?.absoluteString.components(separatedBy: "?")[0])!, parameters: searchParams.APIParams, encoding: Router.BusStop.BusStopSearchEncoding() as ParameterEncoding, headers: [:])
                .flatMap {
                    $0
                        .validate(statusCode: 200 ..< 300)
                        .rx.responseString(encoding: String.Encoding.shiftJIS)
                        .flatMap { (res,html) -> Observable<BusStopSearchResultParameters> in
                            let doc = HTML(html: html, encoding: String.Encoding.utf8)
                            
                            var results = [BusStopSearchResultParameters]()
                            
                            if html.contains("検索文字列を入力して検索しなおしてください。") {
                                return Observable.from(results)
                            }

                            for node in (doc?.css("select, in").first?.css("option"))! {
                                var busStopSearchResultParameters = Mapper<BusStopSearchResultParameters>().map(JSONString: "{}")
                                busStopSearchResultParameters?.name = node.innerHTML!
                                busStopSearchResultParameters?.id = Int(node["value"]!)!
                               results.append(busStopSearchResultParameters!)
                            }
                            
                            return Observable.from(results)
                    }
                }
                .observeOn(MainScheduler.instance)
        }

    }
}
