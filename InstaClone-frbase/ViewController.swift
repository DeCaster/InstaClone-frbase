//
//  ViewController.swift
//  InstaClone-frbase
//
//  Created by Murad on 1.03.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import SwiftUI


class ViewController: UIViewController {

    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.isSecureTextEntry = true//passwordu gizli sekile getirir
        
    
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text! != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
        
        
        
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
        
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
        
    }
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    
}

