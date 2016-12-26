//
//  LoginViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 11/16/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit



class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setup()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.darkGray
        
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup() {
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string:"username",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"password",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.white])
        //configure facebook login button
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fbLoginButton.delegate = self
        
    }
    
    
    func goSignUp () {
        
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        present(destinationVC, animated: true, completion: nil)
        
    }
    
    
    func verifyFields()-> Bool {
        
        if userNameTextField.text == "" || passwordTextField.text == "" {
            return false
        }
        return true
    }
    
    
    
    // MARK: - IBActions
    
    
    @IBAction func touchLoginBtn(_ sender: Any) {
        
        if verifyFields() {
            
            Database.sharedInstance.login(email: userNameTextField.text!, password: passwordTextField.text!, completion: { [unowned self] (success) in
                if success {
                    
                    var tabViewController = UITabBarController()
                    tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabViewController") as! UITabBarController
                    self.present(tabViewController, animated: true, completion: nil)
                    
                } else {
                    
                    //return alert stating username /pw dont' match
                    
                }
                
                
            })
        } else {
            
            //return alert stating fields are not filled out
        }
       
        
    }
    
    
    @IBAction func touchFBLoginBtn(_ sender: Any) {
    }
    
    
    @IBAction func touchSignUpBtn(_ sender: Any) {
        
        goSignUp()
        
    }
    
    
    
    
    
    
    
}



extension LoginViewController: FBSDKLoginButtonDelegate {
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email"]).start { [unowned self] (connection, result, error) in
            
            let data = result as! [String: AnyObject]
            
            let firstName = data["first_name"] as? String
            let lastName = data["last_name"] as? String
            
            guard let picture = data["picture"] as? NSDictionary,
                let dataPicture = picture["data"] as? NSDictionary,
                let url = dataPicture["url"] as? String else {
                    return
            }
            
            let photoUrl = URL(string: url)
            let photoData = try! Data(contentsOf: photoUrl!)
            
            let email = data["email"] as? String
            
            User.sharedInstance.firstName = firstName
            User.sharedInstance.lastName = lastName
            User.sharedInstance.email = email
            User.sharedInstance.picture = photoData
            
            self.goSignUp()
            

        }
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
    }
    
}
