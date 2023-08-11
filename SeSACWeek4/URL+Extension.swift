//
//  URL+Extension.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/11.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/" // 값이 바뀌지 않고 여기저기서 활용되기 때문에 타입 프로퍼티로 선언
    
    static func makeEndPointStringz(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
