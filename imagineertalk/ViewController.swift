//
//  ViewController.swift
//  imagineertalk
//
//  Created by marco on 3/28/17.
//  Copyright © 2017 imagineer. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextView: UITextView!
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var _refHandle: FIRDatabaseHandle!
    
    var targetEmail: String?
    var targetUID: String?
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        var mdata = [String: String]()
        mdata["text"] = chatTextView.text
        mdata["sender"] = FIRAuth.auth()!.currentUser!.uid
        mdata["receiver"] = targetUID
        
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
        configureDatabase()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        let sender = message["sender"]
        var text = "[text]"
        if sender == targetUID {
            text = "\(targetEmail!) : \(message["text"]!)"
        } else {
            text = "Me : \(message["text"]!)"
        }
        
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
        }
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages")
//            .queryOrdered(byChild: "text")
//            .queryEqual(toValue: "Abc")
            .observe(.childAdded, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }

                
                let messageSnapshot: FIRDataSnapshot! = snapshot
                guard let message = messageSnapshot.value as? [String:String] else { return }
//                let text = message["text"] ?? "[text]"
                let sender = message["sender"]
                let receiver = message["receiver"]
                if (sender == strongSelf.targetUID || sender == FIRAuth.auth()!.currentUser!.uid)
                    && (receiver == strongSelf.targetUID || receiver == FIRAuth.auth()!.currentUser!.uid) {
                    strongSelf.messages.append(snapshot)
                    strongSelf.chatTableView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
                }
            })
    }
}

