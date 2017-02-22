//
//  Util.swift
//  HakoBus
//
//  Created by AtsuyaSato on 2017/02/14.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
extension String.Encoding {
    static let windows31j = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.dosJapanese.rawValue)))
}

extension String {
    func addingPercentEncoding(withAllowedCharacters characterSet: CharacterSet, using encoding: String.Encoding) -> String {
        let stringData = self.data(using: encoding, allowLossyConversion: true) ?? Data()
        let percentEscaped = stringData.map {byte->String in
            if characterSet.contains(UnicodeScalar(byte)) {
                return String(UnicodeScalar(byte))
            } else if byte == UInt8(ascii: " ") {
                return "+"
            } else {
                return String(format: "%%%02X", byte)
            }
            }.joined()
        return percentEscaped
    }
    
    /// SJISパーセントエンコーディングを行う
    /// - returns: encodedString
    /// - Remark: http://ja.stackoverflow.com/questions/32636/swift3%E3%81%A7sjis%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%9Furl%E3%82%A8%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%89%E3%82%92%E3%81%97%E3%81%9F%E3%81%84/32640#32640
    var sjisPercentEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved,  using: .windows31j)
    }
}
