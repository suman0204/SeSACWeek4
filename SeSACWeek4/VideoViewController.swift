//
//  VideoViewController.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

//struct Video {
//    let author: String
//    let date: String
//    let time: Int
//    let thumnail: String
//    let title: String
//    let link: String
//    
//    var contents: String {
//        return "\(author) | \(time)회\n\(date)"
//    }
//}

class VideoViewController: UIViewController {
    

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    var videoList: [Document] = [] {
        didSet {
            videoTableView.reloadData()
        }
    }
    
    var page = 1
    var isEnd = false //현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.prefetchDataSource = self
        videoTableView.rowHeight = 140

        searchBar.delegate = self
        
//        KakaoAPIManager.shared.callRequest(type: .video, query: searchBar.text ?? "") { result in
//            self.vclip = result
//        }
        
        
    }
    
    func callRequest(query: String, page: Int) {
//
//        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=10&page=\(page)"
//        let header: HTTPHeaders = ["Authorization" : "KakaoAK \(APIKey.kakao)"]
        
//        KakaoAPIManager.shared.callRequest(type: .video, query: query) { json in
//            print("======\(json)")
//        }
//        KakaoAPIManager.shared.callRequest(type: .video, query: query, page: page) { result in
//            self.isEnd = result.meta.isEnd
//
//            self.videoList = result.documents
//
//            self.videoTableView.reloadData()
//
//        } failure: {
//            print("no Data")
//        }
        
    }
//    AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
//     switch response.result {
//     case .success(let value):
//     let json = JSON(value)
//     print("JSON: \(json)")
//
//     let statusCode = response.response?.statusCode ?? 500
//
//     if statusCode == 200 {
//
//     self.isEnd = json["meta"]["is_end"].boolValue
//
//
//     for item in json["documents"].arrayValue {
//     let author = item["author"].stringValue
//     let date = item["datetime"].stringValue
//     let time = item["play_time"].intValue
//     let thumbnail = item["thumbnail"].stringValue
//     let title = item["title"].stringValue
//     let link = item["url"].stringValue
//
//     let data = Video(author: author, date: date, time: time, thumnail: thumbnail, title: title, link: link)
//
//     self.videoList.append(data)
//     }
//
//     self.videoTableView.reloadData()
//
//     } else {
//     print("문제가 발생했어요. 잠시 후 다시 시도해주세요!")
//     }
//
//
//     //                print(self.videoList)
//
//     case .failure(let error):
//     print(error)
//     }
//     }

}


extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        page = 1 // 새로운 검색어이기 때문에 page를 1로 변경
        videoList.removeAll()
        guard let query = searchBar.text else{
            return
        }
//        callRequest(query: query, page: page)
        
        KakaoAPIManager.shared.callRequest(type: .video, query: query, page: page) { result in
            self.isEnd = result.meta.isEnd
            
            self.videoList = result.documents
            
            self.videoTableView.reloadData()

        } failure: {
            print("no Data")
        }
        
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(videoList.count)
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        print(videoList[indexPath.row].title)
        cell.contentLabel.text = videoList[indexPath.row].contents
        
        if let url = URL(string: videoList[indexPath.row].thumbnail) {
            cell.thumbnailImageiView.kf.setImage(with: url)
            
        }
        
        return cell
    }

    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    //videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    //page count
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && isEnd == false {
                page += 1
//                callRequest(query: searchBar.text!, page: page)
                
                KakaoAPIManager.shared.callRequest(type: .video, query: searchBar.text!, page: page) { result in
                    self.isEnd = result.meta.isEnd
                    
                    self.videoList.append(contentsOf: result.documents)
                    
                    self.videoTableView.reloadData()


                } failure: {
                    print("no Data")
                }
            }
        }
    }
    
    //취소 기능: 직접 취소하는 기능을 구현해주어야 함!
    //빠르게 스크롤할 때 빨리 지나가버린 셀의 데이터를 굳이 다운 받을 필요 없으므로 다운을 취소해줌
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("=====취소: \(indexPaths)")
    }
    
}
