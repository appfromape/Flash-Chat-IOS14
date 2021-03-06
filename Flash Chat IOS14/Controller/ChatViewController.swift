//
//  ChatViewController.swift
//  Flash Chat IOS14
//
//  Created by 程式猿 on 2021/3/1.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(Constants.FStore.collectionName).order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        if let body = data[Constants.FStore.bodyField] as? String, let sendor = data[Constants.FStore.senderField] as? String {
                            let newMessage = Message(sender: sendor, body: body)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageSender = Auth.auth().currentUser?.email {
            if let messageBody = messageTextfield.text {
                db.collection(Constants.FStore.collectionName).addDocument(data: [Constants.FStore.senderField : messageSender,Constants.FStore.bodyField : messageBody, Constants.FStore.dateField : Date().timeIntervalSince1970 ]) { (error) in
                    if let e = error {
                        print(e)
                    } else {
                        print("success")
                    }
                }
                messageTextfield.text = ""
                self.viewDidLoad()
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.lable?.text = message.body
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.lable.textColor = UIColor(named: Constants.BrandColors.purple)
        }
        
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.lable.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        
        return cell
    }
    
}
