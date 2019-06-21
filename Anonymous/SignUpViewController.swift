//
//  SignUpViewController.swift
//  Anonymous
//
//  Created by Paul Ter on 5/20/19.
//  Copyright © 2019 Paul Ter. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMobileAds

class SignUpViewController: UIViewController,GADBannerViewDelegate {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let view = GADBannerView()
        view.frame = CGRect(x: 0, y: self.view.frame.maxY - 50, width: 320, height: 50)
        view.delegate = self
        view.rootViewController = self
        view.adUnitID = "ca-app-pub-1666211014421581/5861230063"
        
        let request = GADRequest()
        request.testDevices = ["ef9251de4a93c10095f1b7a043cd268a"]

        view.load(request)
        
        self.view.addSubview(view)
    }
    

    @IBAction func signUpPressed(_ sender: Any) {
        if(usernameTextfield.text!.count > 4 && passwordTextfield.text!.count > 4 && emailTextfield.text!.count > 4 ){
            
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
                if(error != nil){
                    print(error)
                    let alert = UIAlertController(title: "Invalid login", message: error.debugDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                Database.database().reference().child("Users").child((user?.user.uid)!).setValue(["uid":user?.user.uid,"username":self.usernameTextfield.text,"email":self.emailTextfield.text,"CapitalUsername":self.usernameTextfield.text?.uppercased()])
                
                let home = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.present(home!, animated: true, completion: nil)
                
                
                
            }
            
        }else{
            let alert = UIAlertController(title: "Username and password must be atleast 4 characters", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
