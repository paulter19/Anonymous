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

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
