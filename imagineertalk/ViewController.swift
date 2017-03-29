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
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        var mdata = [String: String]()
        mdata["text"] = chatTextView.text
        
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
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    deinit {
//        if let refHandle = _refHandle {
//            self.ref.child("messages").removeObserver(withHandle: _refHandle)
//        }
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            strongSelf.messages.append(snapshot)
//            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
//        })
    }
}

