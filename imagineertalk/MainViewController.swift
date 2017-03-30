//
//  MainViewController.swift
//  imagineertalk
//
//  Created by marco on 3/30/17.
//  Copyright © 2017 imagineer. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    var handle:FIRAuthStateDidChangeListenerHandle?
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if let user = auth.currentUser {
                self.emailLabel.text = user.email
            }
        }
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
