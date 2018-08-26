//
//  LoginVC.swift
//  peopledex
//
//  Created by Owner on 2018-08-26.
//  Copyright © 2018 hackthe6ix team. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if error == nil{
                print("TEST")
//                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }
}
