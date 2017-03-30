//
//  AuthViewController.swift
//  imagineertalk
//
//  Created by marco on 3/30/17.
//  Copyright © 2017 imagineer. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var isLogin: Bool?
    
    @IBAction func buttonPressed(_ sender: Any) {
//        if let email = emailTextField.text {}
        if isLogin! {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {_, error in
                if (error == nil) {
                    self.performSegue(withIdentifier: "ToMain", sender: sender)
                }
            })
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {_, error in
                if (error == nil) {
                    self.performSegue(withIdentifier: "ToMain", sender: sender)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
