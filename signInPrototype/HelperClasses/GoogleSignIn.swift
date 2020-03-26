//
//  GoogleSignIn.swift
//  signInPrototype
//
//  Created by Greg Hughes on 3/25/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogSignIn : NSObject, GIDSignInDelegate {
    static let shared = GoogSignIn()
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = "968687907018-j3ujbcifrlb9pr9vfjjgqoqs326qek9j.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
    }
    
     func application(_ application: UIApplication,
                        open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
         return GIDSignIn.sharedInstance().handle(url)
       }
       
       @available(iOS 9.0, *)
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
         return GIDSignIn.sharedInstance().handle(url)
       }
       
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
           if let error = error {
             if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
               print("The user has not signed in before or they have since signed out.")
             } else {
               print("\(error.localizedDescription)")
             }
             // [START_EXCLUDE silent]
         NotificationCenter.default.post(
               name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
             // [END_EXCLUDE]
             return
           }
           // Perform any operations on signed in user here.
           let userId = user.userID                  // For client-side use only!
           let idToken = user.authentication.idToken // Safe to send to the server
           let fullName = user.profile.name
           let givenName = user.profile.givenName
           let familyName = user.profile.familyName
           let email = user.profile.email
           // [START_EXCLUDE]
           NotificationCenter.default.post(
             name: Notification.Name(rawValue: "ToggleAuthUINotification"),
             object: nil,
             userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
           // [END_EXCLUDE]
       }
       
       func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                 withError error: Error!) {
         // Perform any operations when the user disconnects from app here.
         // [START_EXCLUDE]
         NotificationCenter.default.post(
           name: Notification.Name(rawValue: "ToggleAuthUINotification"),
           object: nil,
           userInfo: ["statusText": "User has disconnected."])
         // [END_EXCLUDE]
       }
    
    
    
}
