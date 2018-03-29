//
//  LoginViewController.swift
//  Group1Alpha
//
//  Created by Preimesberger, Freya M on 3/28/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginLogo: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        // if username or password field is empty, tells user to enter both
        let userText: String = userField.text!
        let passText: String = passField.text!
        
        if userText=="" || passText=="" {
            warningLabel?.text = "You have to enter both a username and a password."
            warningLabel.center.x = self.view.center.x
        }
        else {
            // database stuff for login
        }
    }
    
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginLogo.center.x = self.view.center.x
        //loginButton.center.x = self.view.center.x
        userLabel.center.x = self.view.center.x - 80.0
        userField.center.x = self.view.center.x + 50.0
        passLabel.center.x = self.view.center.x - 80.0
        passField.center.x = self.view.center.x + 50.0
        warningLabel.center.x = self.view.center.x
        
        // retreat keyboard
        userField.delegate = self
        passField.delegate = self 
    }
    
    // keyboard retreats if user clicks on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // keyboard retreats if user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
