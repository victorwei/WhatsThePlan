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
import CoreData

enum loginError {
    case empty, invalid
}


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    
    @IBOutlet weak var fbLogin: FBSDKLoginButton!
    
    
    
    var currentUsers: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup() {
        
        let credentials = checkCurrentUser()
        if credentials.0 == true {
            let email = credentials.1?[0]
            let password = credentials.1?[1]
            login(email: email!, password: password!)
        }
        
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string:"username",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"password",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.white])
        //configure facebook login button
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fbLoginButton.delegate = self
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //keep the navigation bar translucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        UIApplication.shared.statusBarView?.backgroundColor = nil
    }
    
    
    func goSignUp () {
        
//        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//        present(destinationVC, animated: true, completion: nil)
        
        
        
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let destinationNC = UINavigationController(rootViewController: destinationVC)
        present(destinationNC, animated: true, completion: nil)
        
        
    }
    
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func checkCurrentUser() -> (Bool, [String]?) {
        
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentUser")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            currentUsers = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return (false, nil)
        }
        
        
        if currentUsers.count != 0 {
            
            for user in currentUsers {
                
                if user.value(forKey: "signedIn") as? Bool == true {
                    let email = user.value(forKey: "email") as? String
                    let password = user.value(forKey: "password") as? String
                    let credentials: [String] = [email!, password!]
                    
                    return(true, credentials)
                }
                
            }
        }
        return (false, nil)
        
    }
    
    
    func verifyFields()-> Bool {
        
        if userNameTextField.text == "" || passwordTextField.text == "" {
            return false
        }
        return true
    }
    
    
    
    //alert function
    func invalidLoginAlert(alert: loginError) {
        
        var alertController = UIAlertController()
        
        if alert == .invalid {
            alertController = UIAlertController(title: "Error", message: "Invalid Login.  Username and password do not match.", preferredStyle: .alert)
        } else if alert == .empty {
            alertController = UIAlertController(title: "Error", message: "Please fill out the username and password fields.", preferredStyle: .alert)
        }
        
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func saveCurrentUser() {
        
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "CurrentUser", in: managedContext)
        
        let user = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        user.setValue(userNameTextField.text!, forKey: "email")
        user.setValue(passwordTextField.text!, forKey: "password")
        user.setValue(true, forKey: "signedIn")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.description)")
        }
        
    }
    
    
    
    func login(email: String, password: String) {
        
        Database.sharedInstance.login(email: email, password: password, completion: { [unowned self] (success) in
            if success {
                
                var tabViewController = UITabBarController()
                tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabViewController") as! UITabBarController
                self.present(tabViewController, animated: true, completion: nil)
                
            } else {
                
                //return alert stating username /pw dont' match
                self.invalidLoginAlert(alert: loginError.invalid)
                
            }
            
            
        })
        
        
    }
    
    
    
    // MARK: - IBActions
    
    
    @IBAction func touchLoginBtn(_ sender: Any) {
        
        if verifyFields() {
            
            login(email: userNameTextField.text!, password: passwordTextField.text!)
            saveCurrentUser()
            
        } else {
            
            //return alert stating fields are not filled out
            invalidLoginAlert(alert: loginError.empty)
        
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
