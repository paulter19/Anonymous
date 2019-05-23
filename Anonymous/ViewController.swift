//
//  ViewController.swift
//  Anonymous
//
//  Created by Paul Ter on 5/20/19.
//  Copyright © 2019 Paul Ter. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var myTableView: UITableView!
    
    var messages = [[String:Any]]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Do any additional setup after loading the view.
        self.myTableView.clipsToBounds = true
        self.myTableView.layer.cornerRadius = 10
        getMessages()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageTableViewCell
        
        cell.replyButton.tag = indexPath.row
        
        let dictionary = self.messages[indexPath.row]
        let message = dictionary["message"] as! String
        let date = dictionary["date"] as! String
        
        cell.dateLabel.text = date
        
       cell.messageTextView.text = message
        return cell
    }
    
    func getMessages(){
        Database.database().reference().child("Messages").child(Auth.auth().currentUser!.uid).queryOrdered(byChild: "dateInterval").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any]{
                self.messages.append(dictionary)
                DispatchQueue.main.async {
                    //self.messages = self.messages.reversed()
                    self.myTableView.reloadData()
                }
                
                }
            }
        }
    

    @IBAction func replyPressed(_ sender: Any) {
        print("reply press")
    }
    @IBAction func pressViewMessages(_ sender: Any) {
    }
    
    @IBAction func pressSentMessages(_ sender: Any) {
    }
    @IBAction func pressSearchUsers(_ sender: Any) {
    }
}

