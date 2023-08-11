//
//  UserDefaultsHelper.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/11.
//

import Foundation

class UserDefaultsHelper {
    
    static let standard = UserDefaultsHelper() //싱글턴 패턴
    
    private init() { } //접근 제어자
    
    let userDefaults = UserDefaults.standard

    enum Key: String {
        case nickname, age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
}

