//
//  KakaoAPIManager.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let header: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, page: Int, success: @escaping (VideoResult) -> (), failure: @escaping () -> Void ) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.requestURL + text + "&size=10&page=" + "\(page)"
        
        print(url)
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseDecodable(of: VideoResult.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
                success(value)

            case .failure(let error):
                print("ERROR")
                print(response.response?.statusCode)
                print(error)
            }
        }

//        "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)"
        /*
         func callRequest(query: String, page: Int) {
     //
     //        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
     //        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)"
     //        let header: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakao)"]
             
     //        KakaoAPIManager.shared.callRequest(type: .video, query: query) { json in
     //            print("======\(json)")
     //        }
             KakaoAPIManager.shared.callRequest(type: .video, query: query) { result in
                 self.isEnd = result.meta.isEnd
                 
                 self.videoList = result.documents
                 
                 self.videoTableView.reloadData()

             } failure: {
                 print("no Data")
             }
             
         }
         */
    }
}





// MARK: - Video
struct VideoResult: Codable {
    let documents: [Document]
    let ds: [DS]?
    let g: [G]?
    let m: M?
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let author, datetime: String
    let playTime: Int
    let thumbnail: String
    let title: String
    let url: String
    
    var contents: String {
        return "\(author) | \(playTime)회\n\(datetime)"
    }

    enum CodingKeys: String, CodingKey {
        case author, datetime
        case playTime = "play_time"
        case thumbnail, title, url
    }
}



// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

// MARK: - M
struct M: Codable {
}

// MARK: - DS
struct DS: Codable {
}

// MARK: - G
struct G: Codable {
}

