//
//  SendMessageViewController.swift
//  Anonymous
//
//  Created by Paul Ter on 5/20/19.
//  Copyright © 2019 Paul Ter. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class SendMessageViewController: UIViewController {

    var username:String?
    var uid:String = "I01xvMZqQMboRPIpZeHGniUNnyT2"
    
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var messageText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageText.becomeFirstResponder()
        
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let date = Date.init()
        let dateInterval = (Int)(Date.timeIntervalSinceReferenceDate)
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
       let randomString = UUID.init().uuidString
        let message = self.messageText.text as! String
        Database.database().reference().child("Messages").child(uid).child(randomString).setValue(["date":dateString,"message":message,"dateInterval":dateInterval])
        
        Database.database().reference().child("SentMessages").child(Auth.auth().currentUser!.uid).child(randomString).setValue(["date":dateString,"message":message,"dateInterval":dateInterval])
        
        
        
        self.messageText.text = ""
        let alert = UIAlertController(title: "Sent", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(home!, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    

}
