/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    @IBOutlet weak var registerText: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    var signupMode = true
    @IBAction func login(sender: AnyObject) {
        
        if signupMode{
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            registerText.text = "Not Registered?"
            loginButton.setTitle("Sign Up", forState:  UIControlState.Normal)
            signupMode = false
        }
        else{
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registerText.text = "Already Registered?"
            loginButton.setTitle("Log In", forState:  UIControlState.Normal)
            signupMode = true
            
        }
        
    }
    func displayAlert(title: String, message: String){
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func signup(sender: AnyObject) {
        var errorMessage = "Please Try Again Later"
        if username.text == "" || password.text == ""{
            
            displayAlert("Error in Form", message: "Please Enter a Username and Password")
        }
        else{
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview( activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupMode{
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                user.signUpInBackgroundWithBlock( { (success, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    if error == nil{
                        
                    }
                    else{
                        if let errorString = error!.userInfo["error"] as? String{
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed to sign up", message: errorMessage)
                        
                    }
                })
            }
            else{
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: {(user,error) -> Void in
                    if user != nil {
                        print("Logged in")
                    }   else {
                        if let errorString = error!.userInfo["error"] as? String{
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed to sign up", message: errorMessage)
                    }
                    
                    
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
