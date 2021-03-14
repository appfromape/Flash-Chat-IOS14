//
//  WelcomViewController.swift
//  Flash Chat IOS14
//
//  Created by 程式猿 on 2021/3/1.
//

import UIKit
//import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "⚡️FlashChat"
        for letter in titleText {
//            print(charIndex)
//            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        
//        titleLabel.text = "⚡️FlashChat"
        

       
    }
    

}
