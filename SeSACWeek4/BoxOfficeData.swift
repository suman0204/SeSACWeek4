//
//  BoxOfficeData.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/14.
//

import Foundation

// MARK: - BoxOffice
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
    let showRange: String
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let scrnCnt, salesChange, salesInten, audiInten: String
    let openDt, audiAcc, rankInten, audiCnt: String
    let salesAmt, salesAcc, audiChange, salesShare: String
    let rankOldAndNew: RankOldAndNew
    let movieCD, rank, rnum, movieNm: String
    let showCnt: String

    enum CodingKeys: String, CodingKey {
        case scrnCnt, salesChange, salesInten, audiInten, openDt, audiAcc, rankInten, audiCnt, salesAmt, salesAcc, audiChange, salesShare, rankOldAndNew
        case movieCD = "movieCd"
        case rank, rnum, movieNm, showCnt
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}
