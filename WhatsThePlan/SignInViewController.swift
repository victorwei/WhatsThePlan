//
//  SignInViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 1/27/17.
//  Copyright © 2017 victorW. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    
    //Enum to capture error cases
    enum SignUpError {
        case empty, password, userExists, noerror
    }
    
    
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var userPhoto: Data!
    var formDataSource: SignInData!

    
    let pickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        
    }
    
    
    
    func setup() {
        
        
        let textNib = UINib(nibName: "DescriptionTableViewCell", bundle: nil)
        tableView.register(textNib, forCellReuseIdentifier: "textCell")
        
        let bioNib = UINib(nibName: "SignUpTextView", bundle: nil)
        tableView.register(bioNib, forCellReuseIdentifier: "bioCell")
        
        let userNib = UINib(nibName: "UserImgTableViewCell", bundle: nil)
        tableView.register((userNib), forCellReuseIdentifier: "userCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        formDataSource = SignInData()
        var currentError = SignUpError.noerror
        
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.appTheme
//        
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeUserImg(_:)))
//        self.userImg.addGestureRecognizer(tap)
//        userImg.isUserInteractionEnabled = true
//        
        
//        if let photo = User.sharedInstance.picture {
//            userImg.image = UIImage(data: photo)
//            userPhoto = photo
//        }
        
        
        
        
    }
    
    
    func changeUserImg(_ sender: UITapGestureRecognizer) {
        
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = false
        pickerController.delegate = self
        
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        endEditing()
        checkFields()
    }
    
    
    

}



extension SignInViewController {
    
    
    
    func endEditing() {
        
        for index in 0..<5 {
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.endEditing(true)   
        }
        
    }
    

    
    func checkFields () {
        
        
        guard let fname = formDataSource.fName,
            let lname = formDataSource.lName,
            let email = formDataSource.email,
            let pw = formDataSource.password,
            let pwconfirm = formDataSource.passwordConfirm,
            let bio = formDataSource.bio else {
                
                //Print error:
                print("One of the fields is not filled out")
                
                displayAlert(errortype: SignUpError.empty)
                
                
                return
        }
        
        if pw != pwconfirm {
            print("passwords don't match")
            displayAlert(errortype: SignUpError.password)
            return
        }
        
        
        //check if userphoto is valid
        if userPhoto == nil {
            if let defaultImage = UIImage(named: "defaultUser") {
                userPhoto = UIImagePNGRepresentation(defaultImage)
            }
        }
        
        
        Database.sharedInstance.addUser(firstName: fname, lastName: lname, bio: bio, photo: self.userPhoto, email: email, password: pw, completion: { [unowned self] (success) in
            if success {
                
                self.dismiss(animated: true, completion: nil)
                print("success!")
            } else {
                
                self.displayAlert(errortype: SignUpError.userExists)
                
            }
        })
    }
    
    
    
    
    func displayAlert(errortype: SignUpError) {
        
        var alertController = UIAlertController()
        
        switch errortype {
        case .empty:
            alertController = UIAlertController(title: "!", message: "One or more fields are empty.  Please enter all fields", preferredStyle: .alert)
            
        case .password:
            alertController = UIAlertController(title: "!", message: "Passwords do not match!  Please retype the password", preferredStyle: .alert)
            
        case .userExists:
            alertController = UIAlertController(title: "!", message: "E-mail has already been registered.  Please use a different E-mail", preferredStyle: .alert)
            
        default:
            alertController = UIAlertController(title: "!", message: "No Alert", preferredStyle: .alert)
        }
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
}



extension SignInViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIndex = indexPath.row
        
        
        //Cell to add the bio.  Links to the AddBioVC
        if cellIndex == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath) as! SignUpTextView
            
            cell.backgroundColor = UIColor.init(netHex: 0xF2F2F2)
            cell.accessoryType = .disclosureIndicator
            return cell
            
            
        }  else if cellIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserImgTableViewCell
            cell.selectionStyle = .none
            
            
            if let photo = User.sharedInstance.picture {
                cell.userImgView.image = UIImage(data: photo)
                userPhoto = photo
            }
       
            
            //Add tap gesture recognizer for the ImageView
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeUserImg(_:)))
            cell.userImgView.isUserInteractionEnabled = true
            cell.userImgView.addGestureRecognizer(tap)
            
            //Make sure the user image is a circle
            cell.roundUserImg()
            
            return cell
            
            
            
        }  else {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! DescriptionTableViewCell
            
            switch cellIndex {
            case 1:
                cell.topLabel.text = "First Name"
                cell.textField.placeholder = ""
                
                if let first_name = User.sharedInstance.firstName {
                    cell.textField.text = first_name
                }
                
            case 2:
                cell.topLabel.text = "Last Name"
                cell.textField.placeholder = ""
                
                if let last_name = User.sharedInstance.lastName {
                    cell.textField.text = last_name
                }
                
            case 3:
                cell.topLabel.text = "Email"
                cell.textField.placeholder = ""
                
                if let email = User.sharedInstance.email {
                    cell.textField.text = email
                }
                
            case 4:
                cell.topLabel.text = "Password"
                cell.textField.placeholder = ""
            case 5:
                cell.topLabel.text = "Retype Password"
                cell.textField.placeholder = ""
            default:
                print("Error")
            }
            
            cell.textField.delegate = self
            cell.textField.tag = cellIndex
            cell.selectionStyle = .none
            
            return cell
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            
            
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddBioViewController") as! AddBioViewController
            VC.delegate = self
            if let currentBio = formDataSource.bio {
                VC.bio = currentBio
            }
            
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return self.view.frame.height/5
        } else {
               return UITableViewAutomaticDimension
        }
     
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height/5
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}


extension SignInViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var text = ""
        
        switch textField.tag {
        
        case 1:
            if let inputText = textField.text {
                text = inputText
                formDataSource.fName = text
            }
        
        case 2:
            if let inputText = textField.text {
                text = inputText
                formDataSource.lName = text
            }
        case 3:
            if let inputText = textField.text {
                text = inputText
                formDataSource.email = text
            }
        case 4:
            if let inputText = textField.text {
                text = inputText
                formDataSource.password = text
            }
        case 5:
            if let inputText = textField.text {
                text = inputText
                formDataSource.passwordConfirm = text
            }
        default:
            print("Invalid textField")
        }
    }
}


extension SignInViewController: AddBio {
    
    func addBio(bio: String) {
        
        formDataSource.bio = bio
        
        //change the cell label to reflec the bio text
        let indexPath = IndexPath(row: 6, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SignUpTextView
        cell.infoLabel.text = bio
        
        tableView.reloadData()
    }
}



extension SignInViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //userImg.image = imagePicked
            
            let cellIndex = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: cellIndex) as! UserImgTableViewCell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: cellIndex) as! UserImgTableViewCell
            
            DispatchQueue.main.async {
                cell.userImgView.image = imagePicked
            }
            
            userPhoto = UIImagePNGRepresentation(imagePicked)
            
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
