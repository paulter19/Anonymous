//
//  SignInViewController.swift
//  Anonymous
//
//  Created by Paul Ter on 5/20/19.
//  Copyright © 2019 Paul Ter. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds

class SignInViewController: UIViewController,GADBannerViewDelegate {
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = GADBannerView()
        view.frame = CGRect(x: 0, y: self.view.frame.maxY - 50, width: 320, height: 50)
        view.delegate = self
        view.rootViewController = self
        view.adUnitID = "ca-app-pub-1666211014421581/5861230063"
        view.load(GADRequest())
        self.view.addSubview(view)


        // Do any additional setup after loading the view.
        if(Auth.auth().currentUser != nil){
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(home!, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser != nil){
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(home!, animated: true, completion: nil)
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.usernameTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
            if(error != nil){
                print(error)
                let alert = UIAlertController(title: "Invalid login", message: error.debugDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(home!, animated: true, completion: nil)
        }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
