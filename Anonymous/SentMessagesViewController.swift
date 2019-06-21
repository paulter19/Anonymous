//
//  SentMessagesViewController.swift
//  Anonymous
//
//  Created by Paul Ter on 5/20/19.
//  Copyright © 2019 Paul Ter. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMobileAds

class SentMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate {
    
    var messages = [[String:Any]]()
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        getMessages()
        let view = GADBannerView()
        view.frame = CGRect(x: 0, y: self.view.frame.maxY - 50, width: 320, height: 50)
        view.delegate = self
        view.rootViewController = self
        view.adUnitID = "ca-app-pub-1666211014421581/5861230063"
        view.load(GADRequest())
        self.view.addSubview(view)


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
        Database.database().reference().child("SentMessages").child(Auth.auth().currentUser!.uid).queryOrdered(byChild: "dateInterval").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any]{
                self.messages.append(dictionary)
                DispatchQueue.main.async {
                    
                    self.messages = self.messages.sorted(by:{
                        $0["dateInterval"] as! Int > $1["dateInterval"] as! Int
                    })
                    self.myTableView.reloadData()
                }
                
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
