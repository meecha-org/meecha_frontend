//
//  TextFieldMail.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/02.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var Button: UIButton!


    override func viewDidLoad() {
//        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    //メールアドレスかどうかのクラス
    class func isValidMailAddress(_ string: String) -> Bool {
            let mailAddressRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let mailAddressTest = NSPredicate(format:"SELF MATCHES %@", mailAddressRegEx)
            let result = mailAddressTest.evaluate(with: string)
            return result
     }


    @IBAction func ButtonTouchUpInside(_ sender: Any) {
        //メールアドレスが正しい時
        if ViewController.isValidMailAddress(self.TextField.text!) {
            Label.text = "正しいメールアドレスです"
        //メールアドレスが正しくない時
        } else {
            Label.text = "正しいメールアドレスを入力してください"
        }
    }


}

