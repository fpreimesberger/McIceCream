//
//  LoginViewController.swift
//  Group1Alpha
//
//  Created by Preimesberger, Freya M on 3/28/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginLogo: UIImageView!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        // if username or password field is empty, tells user to enter both
        let emailText: String = emailField.text!
        let passText: String = passField.text!
        
        if emailText=="" || passText=="" {
            warningLabel?.text = "You have to enter both an email and a password."
            warningLabel.center.x = self.view.center.x
        }
        else {
            // database stuff for login
            Auth.auth().signIn(withEmail: emailText, password: passText) { (user,error) in
                if error == nil {
                    //signIn successfull
                    self.performSegue(withIdentifier: "mapSegue", sender: nil)
                }else{
                    //signIn failure
                    self.warningLabel?.text = error?.localizedDescription
                }
            }
        }
    }
    
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginLogo.center.x = self.view.center.x
        //loginButton.center.x = self.view.center.x
        emailLabel.center.x = self.view.center.x - 80.0
        emailField.center.x = self.view.center.x + 50.0
        passLabel.center.x = self.view.center.x - 80.0
        passField.center.x = self.view.center.x + 50.0
        warningLabel.center.x = self.view.center.x
        
        // retreat keyboard
        emailField.delegate = self
        passField.delegate = self 
    }
    
    // keyboard retreats if user clicks on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // keyboard retreats if user hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // FIX IF USER AND PASS ARE FILLED IN SO THEY CAN LOGIN!!!
        
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
