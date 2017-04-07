//
//  MainViewController.swift
//  imagineertalk
//
//  Created by marco on 3/30/17.
//  Copyright © 2017 imagineer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref: FIRDatabaseReference!
    var users: [FIRDataSnapshot]! = []
    var _refHandle: FIRDatabaseHandle!
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    var handle:FIRAuthStateDidChangeListenerHandle?
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print("signout failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if let user = auth.currentUser {
                self.emailLabel.text = user.email
            } else {
                self.emailLabel.text = "로그아웃 됨"
            }
        }
        // Do any additional setup after loading the view.
        configureDatabase()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.userTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let userSnapshot: FIRDataSnapshot! = self.users[indexPath.row]
        guard let user = userSnapshot.value as? [String:String] else { return cell }
        let text = user["email"] ?? "[email]"
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChatDetailSegue", sender: self)
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("users").removeObserver(withHandle: refHandle)
        }
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users")
            //            .queryOrdered(byChild: "text")
            //            .queryEqual(toValue: "Abc")
            .observe(.childAdded, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.users.append(snapshot)
                strongSelf.userTableView.insertRows(at: [IndexPath(row: strongSelf.users.count-1, section: 0)], with: .automatic)
            })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userSnapshot: FIRDataSnapshot! = self.users[userTableView.indexPathForSelectedRow!.row]
        guard let user = userSnapshot.value as? [String:String] else { return }
        
        let viewController = segue.destination as! ViewController
        
        viewController.targetEmail = user["email"] ?? "[email]"
        viewController.targetUID = userSnapshot.key
    }

}
