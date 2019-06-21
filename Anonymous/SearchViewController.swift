//
//  SearchViewController.swift
//  Anonymous
//
//  Created by Paul Ter on 5/20/19.
//  Copyright © 2019 Paul Ter. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GADBannerViewDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var users = [[String:Any]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let dict = self.users[indexPath.row]
        
        cell?.textLabel?.text = dict["username"] as! String
        cell?.detailTextLabel?.text = dict["email"] as! String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.users[indexPath.row]
        let username = dict["username"] as! String
        let email = dict["email"] as! String
        let uid = dict["uid"] as! String
        
        let postview = self.storyboard?.instantiateViewController(withIdentifier: "Post") as!SendMessageViewController
        self.present(postview, animated: true) {
            postview.username = username
            postview.uid = uid
            postview.sendToLabel.text = "Send to \(username)"
        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Database.database().reference().child("Users").queryOrdered(byChild: "CapitalUsername").queryEqual(toValue: searchText.uppercased()).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any]{
                for dict in dictionary.values{
                    let d = dict as! [String:Any]
                    self.users.append(d)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myTableView.clipsToBounds = true
        self.myTableView.layer.cornerRadius = 10
        let view = GADBannerView()
        view.frame = CGRect(x: 0, y: self.view.frame.maxY - 50, width: 320, height: 50)
        view.delegate = self
        view.rootViewController = self
        view.adUnitID = "ca-app-pub-1666211014421581/5861230063"
        view.load(GADRequest())
        self.view.addSubview(view)

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
