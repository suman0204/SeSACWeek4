//
//  AsyncViewController.swift
//  SeSACWeek4
//
//  Created by 홍수만 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    @IBOutlet var first: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var third: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        first.backgroundColor = .black
        print("1")
        DispatchQueue.main.async {
            print("2")
            self.first.layer.cornerRadius = self.first.frame.width / 2
        }
        
        print("3")
    }
    
    //sync async serial concurrent
    //UI Freezing
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        // 다른 알바생에게 오래걸리는 일을 맡긴다
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                //UI관련 작업은 main에서만 작업해야한다
                self.first.image = UIImage(data: data)
            }
        }
        
    }
    
}
