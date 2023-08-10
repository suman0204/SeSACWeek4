//
//  TranslationPickerViewController.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Language: String, CaseIterable {
    case ko = "Korean"
    case en = "English"
    case ja = "Japanese"
    
    var returnLanType: String {
        switch self {
        case .ko:
            return "ko"
        case .en:
            return "en"
        case .ja:
            return "ja"
        }
    }
    
}


class TranslationPickerViewController: UIViewController {
    
    var languageList = Language.allCases
    
    var source: String = "ko"
    var target: String = "ko"
        
    let toBeTranslatedTextPlaceholder = "번역하고 싶은 내용을 입력해주세요"
    let translatedTextPlaceholder = "번역된 내용이 나옵니다"
    
    @IBOutlet var toBeTranslatedPicker: UIPickerView!
    @IBOutlet var translatedPicker: UIPickerView!
    
    @IBOutlet var toBeTranslatedText: UITextView!
    @IBOutlet var translatedText: UITextView!
    
    @IBOutlet var translateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toBeTranslatedPicker.delegate = self
        toBeTranslatedPicker.dataSource = self
        
        translatedPicker.delegate = self
        translatedPicker.dataSource = self
        
        toBeTranslatedText.delegate = self
        translatedText.delegate = self
        
        toBeTranslatedText.text = translatedTextPlaceholder
        toBeTranslatedText.textColor = .lightGray
        
        translatedText.isEditable = false
        translatedText.text = toBeTranslatedTextPlaceholder
        translatedText.textColor = .lightGray
        
        translateButton.setTitle("번역하기", for: .normal)
        translateButton.tintColor = .black
        translateButton.layer.cornerRadius = 10
        translateButton.layer.borderColor = UIColor.black.cgColor
        translateButton.layer.borderWidth = 2
        

        
        print(type(of: languageList[0]))
    }
    
    @IBAction func translateButtonClicked(_ sender: UIButton) {
        callRequest()
        translatedText.textColor = .black
    }
    


}

extension TranslationPickerViewController {
    func callRequest() {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverID,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        
        let parameters: Parameters = [
            "source": self.source,
            "target": self.target,
            "text": toBeTranslatedText.text ?? ""
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = json["message"]["result"]["translatedText"].stringValue
                
                self.translatedText.text = data
                
            case .failure(let error):
                print(error)
                self.alert()
            }
        }

    }
    
    func alert() {
        let alert = UIAlertController(title: "오류입니다", message: "내용을 입력해주시거나 서로 다른 언어를 선택해주세요", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)

    }
}


extension TranslationPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(languageList[row].rawValue)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == toBeTranslatedPicker {
            source = languageList[row].returnLanType
        } else if pickerView == translatedPicker {
            target = languageList[row].returnLanType
        }
        print("select \(row)")
    }
}


extension TranslationPickerViewController: UITextViewDelegate {

    //textView의 placeholder만들기
    //편집이 시잘될 때 (커서가 시작될 때)
    //플레이스 홀더와 텍스트뷰 글자가 같다면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(#function)
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    //편집이 끝날 때 (커서가 없어지는 순간)
    //사용자가 아무 글자도 안 썼으면 플레이스 홀더 글자 보이게 설정!
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if toBeTranslatedText.text.isEmpty {
            toBeTranslatedText.text = toBeTranslatedTextPlaceholder
            toBeTranslatedText.textColor = .lightGray
        } else if translatedText.text.isEmpty {
            translatedText.text = translatedTextPlaceholder
            translatedText.textColor = .lightGray
        }
    }
}
