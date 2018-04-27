//
//  CommentsStuffViewController.swift
//  Group1Alpha
//
//  Created by Preimesberger, Freya M on 4/26/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class CommentsStuffViewController: UIViewController {
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var firstCommentLbl: UILabel!
    @IBOutlet weak var secondCommentLbl: UILabel!
    @IBOutlet weak var thirdCommentLbl: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var notWorkingBtn: UIButton!
    @IBOutlet weak var workingBtn: UIButton!
    @IBOutlet weak var submitCmntBtn: UIButton!
    var alertController: UIAlertController? = nil
    var marker:GMSMarker?
    var ref = Database.database().reference()
    
    @IBAction func workingBtnHandler(_ sender: Any) {
        statusLbl?.text = "WORKING"
        self.ref.child("places").child((marker!.title)!).setValue(["isOn": 1])
    }
    
    @IBAction func notWorkingBtnHandler(_ sender: Any) {
        statusLbl?.text = "NOT WORKING"
        self.ref.child("places").child((marker!.title)!).setValue(["isOn": 0])
    }
    // Comment from user is submitted. Alert pops up saying it's been submitted.
    @IBAction func submitBtnHandler(_ sender: Any) {
        let comment = commentTextField?.text
        self.ref.child("places").child((marker!.title)!).child("comments").childByAutoId().setValue(comment)
        self.alertController = UIAlertController(title: "Comment submitted", message: "Thanks!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) {
            (action:UIAlertAction) in print("OK button")
        }
        self.alertController!.addAction(OKAction)
        self.present(self.alertController!, animated: true, completion: nil)
        grabComments()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comments"
        self.checkStatus(address:(marker!.title)!){ isOn in
            if( isOn == 1 ){
                self.statusLbl?.text = "WORKING"
            }else if ( isOn == 0 ){
                self.statusLbl?.text = "NOT WORKING"
            }else if ( isOn == -1){
                self.statusLbl?.text = "NO DATA"
            }
        }
        // Constraints
        commentTextField.center.x = view.center.x
        workingBtn.center.x = view.center.x - 50
        notWorkingBtn.center.x = view.center.x + 50
        submitCmntBtn.center.x = view.center.x
        
        grabComments()
        
    }
        
        // Grab comments info from database and fill in. The labels are there just empty
    func grabComments(){
        self.ref.child("places").child((marker!.title)!).queryOrdered(byChild: "comment").queryLimited(toFirst: 3).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let commentList = value?["comments"] as? NSDictionary
            var iter = 0
            if commentList != nil{
                for (_,value) in commentList!{
                    if iter == 0 {
                        self.firstCommentLbl?.text = value as? String
                    }
                    else if iter == 1{
                        self.secondCommentLbl?.text = value as? String
                    }else if iter == 2{
                        self.thirdCommentLbl?.text = value as? String
                    }
                    iter += 1
                }
            }
            })
        }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkStatus(address: String, completion: @escaping (Int64) -> Void){
        var isOn: Int64?
        self.ref.child("places").child(address).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            isOn = value?["isOn"] as? Int64
            if isOn != nil{
                completion(isOn!)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
