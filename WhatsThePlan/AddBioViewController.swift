//
//  AddBioViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 2/3/17.
//  Copyright © 2017 victorW. All rights reserved.
//

import UIKit

class AddBioViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: AddBio!
    
    var bio: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
    }
    
    func setup() {
        
        textView.delegate = self
        
        if let currentBio = bio {
            textView.text = currentBio
        } else {
            textView.text = "Add bio"
            textView.textColor = UIColor.lightGray
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBio(_ sender: Any) {
        
        guard let text = textView.text else {
            return
        }
        
        if text == "" {
            return
        }
        
        delegate.addBio(bio: text)
        
        self.navigationController?.popViewController(animated: true)
        
        
        
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

extension AddBioViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //if the textColor is grey, that means the "placeholder text" is being shown.  Clear it and set the textColor to black
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
    }
    
    
}


protocol AddBio: NSObjectProtocol {
    func addBio(bio: String)
}
