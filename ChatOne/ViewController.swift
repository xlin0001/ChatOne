//
//  ViewController.swift
//  ChatOne
//
//  Created by 沈宇帆 on 24/1/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var uNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 5
        registerBtn.titleEdgeInsets.left = 35
        // Do any additional setup after loading the view, typically from a nib.
    }


}

