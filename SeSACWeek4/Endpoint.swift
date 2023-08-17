//
//  Endpoint.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/11.
//

import Foundation

enum Endpoint {
    case blog
    case cafe
    case video
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointStringz("blog?query=")
        case .cafe:
            return URL.makeEndPointStringz("cafe?query=")
        case .video:
            return URL.makeEndPointStringz("vclip?query=")
        }
    }
}
