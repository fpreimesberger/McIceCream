//
//  RegisterViewController.swift
//  Group1Alpha
//
//  Created by Preimesberger, Freya M on 3/28/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var registerLogo: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var passField: UITextField!
    
    @IBAction func makeAcctButton(_ sender: Any) {
        // if username or password field is empty, tells user to enter both
        let emailText: String = emailField.text!
        let passText: String = passField.text!
        
        if emailText=="" || passText=="" {
            warningLabel?.text = "You have to enter both a email and a password."
        }
        else {
            // store in Firebase
            Auth.auth().createUser(withEmail: emailText, password: passText) { (user,error) in
                if error == nil {
                    //registration successfull
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }else{
                    //registration failure
                    self.warningLabel?.text = error?.localizedDescription
                }
            }
            
        }
    }
    
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerLogo.center.x = self.view.center.x
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
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
