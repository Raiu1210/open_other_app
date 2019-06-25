//
//  ViewController.swift
//  open_other_app
//
//  Created by Ryu Ishibashi on 2019/06/24.
//  Copyright © 2019 Ryu Ishibashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let address_field = UITextField()
    let amount_field = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        create_how_to_label()
        create_address_field()
        create_amount_field()
        create_open_button()
        create_send_button()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        check_existing_monawallet()
    }
    
    internal func create_open_button() {
        let open_button = UIButton()
        open_button.setTitle("Monawalletを開く", for: .normal)
        open_button.backgroundColor = UIColor.orange
        open_button.sizeToFit()
        open_button.frame = CGRect(x: 10, y: 200, width: UIScreen.main.bounds.size.width-20, height: 38)
        open_button.addTarget(self, action: #selector(open_monawallet(_:)), for: .touchUpInside)
        
        self.view.addSubview(open_button)
    }
    
    internal func create_how_to_label() {
        let how_to_label = UILabel()
        how_to_label.frame = CGRect(x: 10, y: 250, width: UIScreen.main.bounds.size.width-20, height: 38)
        how_to_label.text = "金額リクエストを含んだ文字列を入れてね"
        how_to_label.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(how_to_label)
    }
    
    internal func create_address_field() {
        address_field.text = "Your address here!"
        address_field.frame = CGRect(x: 10, y: 300, width: UIScreen.main.bounds.size.width-150, height: 38)
        address_field.keyboardType = .default
        address_field.borderStyle = .roundedRect
        address_field.returnKeyType = .done
        address_field.clearButtonMode = .always
        address_field.delegate = self
        self.view.addSubview(address_field)
    }
    
    internal func create_amount_field() {
        amount_field.frame = CGRect(x: UIScreen.main.bounds.size.width-130, y: 300, width: 100, height: 38)
        amount_field.keyboardType = .decimalPad
        amount_field.borderStyle = .roundedRect
        amount_field.returnKeyType = .done
        amount_field.clearButtonMode = .always
        amount_field.delegate = self
        self.view.addSubview(amount_field)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    internal func create_send_button() {
        let open_button = UIButton()
        open_button.setTitle("Monawalletで送金する", for: .normal)
        open_button.backgroundColor = UIColor.orange
        open_button.sizeToFit()
        open_button.frame = CGRect(x: 10, y: 400, width: UIScreen.main.bounds.size.width-20, height: 38)
        open_button.addTarget(self, action: #selector(send_mona_by_monawallet(_:)), for: .touchUpInside)
        
        self.view.addSubview(open_button)
    }
    
    @objc func open_monawallet(_ sender:UIButton) {
        let url = URL(string: "monawallet://")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func send_mona_by_monawallet(_ sender: UIButton) {
        let address = self.address_field.text!
        let ammount = self.amount_field.text!
        let request_text = "monacoin:\(address)?amount=\(ammount)"
        
        let url = URL(string: request_text)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // Monawalletがインストールされているか確認して
    // インストールされていない場合はApp storeへ飛ぶAlertを出す
    internal func check_existing_monawallet() {
        if UIApplication.shared.canOpenURL(URL(string: "monawallet://")!) {
            print("Monawallet インストール済み")
        } else {
            print("Monawallet インストールされていない")
            let alert: UIAlertController = UIAlertController(title: "Monawalletがインストールされていません", message: "このアプリを使うにはMonawalletが必要です。App storeからMonawalletをダウンロードしてください", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                let url = URL(string: "https://apps.apple.com/jp/app/monawallet/id1343235820")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:]) { success in
                        if success {
                            print("Launching \(url) was successful")
                        }
                    }
                }
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Canceled")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
