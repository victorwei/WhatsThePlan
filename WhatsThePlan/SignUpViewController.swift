//
//  SignUpViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/13/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    // MARK: - Properties
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    var userPhoto: Data!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setup() {
        
        userImgView.layer.cornerRadius = userImgView.frame.width / 2
        userImgView.clipsToBounds = true
        
        
        if let first_name = User.sharedInstance.firstName {
            fNameTextField.text = first_name
        }
        
        if let last_name = User.sharedInstance.lastName {
            lNameTextField.text = last_name
        }
        
        
        if let email = User.sharedInstance.email {
            emailTextField.text = email
        }
        
        if let photo = User.sharedInstance.picture {
            userImgView.image = UIImage(data: photo)
            userPhoto = photo
        }
        
        
    }
    
    
    
    func verifyFields() {
        
        if fNameTextField.text == "" || lNameTextField.text == "" ||
            emailTextField.text == "" || passwordTextField.text == "" ||
            passwordConfirmTextField.text == "" || bioTextView.text == "" {
            
            //alert user
            return
        }
        
        if passwordTextField.text != passwordConfirmTextField.text {
            
            //alert user
            return
        }
        
        
        Database.sharedInstance.addUser(firstName: self.fNameTextField.text!, lastName: self.lNameTextField.text!, bio: self.bioTextView.text!, photo: self.userPhoto, email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { [unowned self] (success) in
            if success {
                
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                //alert user that email/combo already exists
            }
        })
        
    }
    
    
    

    
    


    // MARK: - IBActions
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        verifyFields()
    }

}
