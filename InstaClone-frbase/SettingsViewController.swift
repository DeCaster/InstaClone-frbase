//
//  SettingsViewController.swift
//  InstaClone-frbase
//
//  Created by Murad on 2.03.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("Problem With Logout proccess")
        }
        
    }
    
}
