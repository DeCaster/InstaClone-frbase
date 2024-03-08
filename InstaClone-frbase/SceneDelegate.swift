//
//  SceneDelegate.swift
//  InstaClone-frbase
//
//  Created by Murad on 1.03.2024.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let currentUser = Auth.auth().currentUser //guncel kullaniciyi aliyor
        
        if currentUser != nil{
            let board = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = board.instantiateViewController(identifier: "tabBar") as! UITabBarController
            
            window?.rootViewController = tabBar
            
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    
    }

    func sceneWillResignActive(_ scene: UIScene) {
    
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}

