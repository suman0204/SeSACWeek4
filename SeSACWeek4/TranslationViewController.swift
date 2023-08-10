//
//  TranslationViewController.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController {

    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
        
        
//        let alert = UIAlertController(title: "dd", message: "jk", preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "확인", style: .default) { <#UIAlertAction#> in
//            <#code#>
//        }
//        
//        alert.addAction(action)
//        present(alert, animated: true)
//        present(alert, animated: true) {
//            <#code#>
//        }
    }
    

    @IBAction func requestButtonClicked(_ sender: UIButton) {
        calldetectLangs()
    }
    

}

extension TranslationViewController {
    func calldetectLangs() {
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverID,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        
        let parameters: Parameters = [
            "query" : originalTextView.text ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let source = json["langCode"].stringValue
                self.callPapagoTranslationRequest(source: source)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callPapagoTranslationRequest(source: String) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverID,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        
        let parameters: Parameters = [
            "source": source,
            "target": "ja",
            "text": originalTextView.text ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                
                self.translateTextView.text = data
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
