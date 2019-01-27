//
//  RegisterViewController.swift
//  ChatOne
//
//  Created by 沈宇帆 on 26/1/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var passwordAgainText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text, let passwordAgain = passwordAgainText.text else{
            print("not valid")
            return
        }
        
        //verify the password
        if password != passwordAgain {
            let alert = UIAlertController(title: "Error", message: "Passwords doesn't match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //create a user
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            

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
