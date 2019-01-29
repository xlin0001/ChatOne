//
//  LoginViewController.swift
//  ChatOne
//
//  Created by 沈宇帆 on 28/1/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UINavigationControllerDelegate {


    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.cornerRadius = 5
        self.registerBtn.titleEdgeInsets.left = 35
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginUser(_ sender: Any) {
        Auth.auth().signIn(withEmail: nameText.text!, password: passwordText.text!) { (authResult, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
                // Presents alert view controller modally.
                self.present(alert, animated: true)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
