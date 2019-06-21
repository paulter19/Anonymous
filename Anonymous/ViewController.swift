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
import GoogleMobileAds

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate {
    
    

    @IBOutlet weak var myTableView: UITableView!
    
    var messages = [[String:Any]]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Do any additional setup after loading the view.
        self.myTableView.clipsToBounds = true
        self.myTableView.layer.cornerRadius = 10
        getMessages()
        let view = GADBannerView()
        view.frame = CGRect(x: 0, y: self.view.frame.maxY - 50, width: 320, height: 50)
        view.delegate = self
        view.rootViewController = self
        view.adUnitID = "ca-app-pub-1666211014421581/5861230063"
        view.load(GADRequest())
        self.view.addSubview(view)
        


    }
    
    
    @IBAction func pressLogout(_ sender: Any) {
        if(Auth.auth().currentUser != nil){
            do  {
                try Auth.auth().signOut()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SignIn")
                self.present(signIn!, animated: false, completion: nil)
            }catch{
                
            }
        }
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
                    self.messages = self.messages.sorted(by:{
                        $0["dateInterval"] as! Int > $1["dateInterval"] as! Int
                    })
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
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

