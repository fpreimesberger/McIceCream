//
//  CommentsStuffViewController.swift
//  Group1Alpha
//
//  Created by Preimesberger, Freya M on 4/26/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import UIKit

class CommentsStuffViewController: UIViewController {
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var firstCommentLbl: UILabel!
    @IBOutlet weak var secondCommentLbl: UILabel!
    @IBOutlet weak var thirdCommentLbl: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var updateBtnCntr: UIButton!
    @IBOutlet weak var submitBtnCntr: UIButton!
    var alertController: UIAlertController? = nil
    
    // If machine is working, change to not working and vice-versa. I made working the default
    @IBAction func updateBtnHandler(_ sender: Any) {
        if statusLbl?.text == "WORKING" {
            statusLbl?.text = "NOT WORKING"
        }
        else {
            statusLbl?.text = "WORKING"
        }
        // Send info to database here
    }
    
    // Comment from user is submitted. Alert pops up saying it's been submitted.
    @IBAction func submitBtnHandler(_ sender: Any) {
        let comment = commentTextField?.text
        // Add comment to database here
        // Alert when comment is submitted
        self.alertController = UIAlertController(title: "Comment submitted", message: "Thanks!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) {
            (action:UIAlertAction) in print("OK button")
        }
        self.alertController!.addAction(OKAction)
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comments"
        statusLbl?.text = "WORKING"
        // Constraints
        commentTextField.center.x = view.center.x
        updateBtnCntr.center.x = view.center.x
        submitBtnCntr.center.x = view.center.x
        
        // Grab comments info from database and fill in. The labels are there just empty
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
