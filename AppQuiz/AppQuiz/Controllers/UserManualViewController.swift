//
//  UserManualViewController.swift
//  AppQuiz
//
//  Created by Taof on 8/28/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class UserManualViewController: UIViewController, WKNavigationDelegate {

    deinit {
        print("Huỷ UserManualViewController")
    }
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        view.backgroundColor = UIColor.white
        navigationItem.title = "Hướng dẫn sử dụng"
        self.setupSlideMenuItem()
        
        SVProgressHUD.show()
        
        let url = URL(string: "https://google.com")!
        webView.load(URLRequest(url: url))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("abc")
            SVProgressHUD.dismiss()
        }
    }

}
