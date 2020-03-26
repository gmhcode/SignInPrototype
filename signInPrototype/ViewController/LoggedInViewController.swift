//
//  LoggedInViewController.swift
//  signInPrototype
//
//  Created by Greg Hughes on 3/26/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    
    var user : User! {
        didSet {
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        firstNameLabel.text = "Full Name: " + user.firstName + " \(user.lastName)"
        lastNameLabel.text = user.email
        emailLabel.text = user.userID
        userIDLabel.text = user.uuid.uuidString

        // Do any additional setup after loading the view.
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
