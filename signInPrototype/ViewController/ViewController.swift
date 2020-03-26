//
//  ViewController.swift
//  signInPrototype
//
//  Created by Greg Hughes on 3/25/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices


class ViewController: UIViewController {

    


    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginStackView: UIStackView!
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        setupProviderLoginView()
        loadKeychain()
        stuff()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        performExistingAccountSetupFlows()
    }
    
    
    func loadKeychain() {
        if let receivedData = KeyChain.load(key: "signInPrototypeUserID") {
            let result = String(data: receivedData, encoding: .utf8) ?? " "
            print("result: ", result)
        }
    }
    
    func stuff() {
        let defaults = UserDefaults.standard
        
        if var user = defaults.array(forKey: "User") as? [User] {
            
            
            //   when itemArray is changed vv saves the change
            defaults.set(user, forKey: "User")
        }else {
            print("blah")
        }
    }
    func saveUser(user:User) {
        let defaults = UserDefaults.standard
        defaults.set(user, forKey: "User")
    }
    func performExistingAccountSetupFlows() {
           // Prepare requests for both Apple ID and password providers.
           let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                           ASAuthorizationPasswordProvider().createRequest()]
           
           // Create an authorization controller with the given requests.
           let authorizationController = ASAuthorizationController(authorizationRequests: requests)
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
       }
    
    func setupProviderLoginView() {
           let authorizationButton = ASAuthorizationAppleIDButton()
           authorizationButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
           self.loginStackView.addArrangedSubview(authorizationButton)
       }
    
    @IBAction func signOutTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    @objc func appleButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? LoggedInViewController
        destination?.user = user
        
    }
    
}

extension ViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
   
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let firstName = appleIDCredential.fullName
           
            let token = appleIDCredential.identityToken
           
            
            
            
            // For the purpose of this demo a   pp, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
            if let email = appleIDCredential.email {
                
                
                self.user = User(userID: userIdentifier, email: email, firstName: firstName?.givenName, lastName: firstName?.familyName)
                let idData = user?.uuid.uuidString.data(using: .utf8)
                KeyChain.save(key: "signInPrototypeUserID", data: idData!)
                performSegue(withIdentifier: "segue", sender: nil)
            }
            // For the purpose of this demo app, show the Apple ID credential information in the 
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    private func saveUserInKeychain(_ userIdentifier: String) {
           do {
               try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
           } catch {
               print("Unable to save userIdentifier to keychain.")
           }
       }
//    private func showResultViewController(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
//        guard let viewController = self.presentingViewController as? ResultViewController
//            else { return }
//
//        DispatchQueue.main.async {
//            viewController.userIdentifierLabel.text = userIdentifier
//            if let givenName = fullName?.givenName {
//                viewController.givenNameLabel.text = givenName
//            }
//            if let familyName = fullName?.familyName {
//                viewController.familyNameLabel.text = familyName
//            }
//            if let email = email {
//                viewController.emailLabel.text = email
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
}
