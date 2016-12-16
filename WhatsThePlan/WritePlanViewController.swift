//
//  WritePlanViewController.swift
//  WhatsThePlan
//
//  Created by Victor Wei on 12/5/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class WritePlanViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    weak var delegate: WritePlanProtocol!
    let placeHolderText =
        "Example:  As someone born in San Francisco, this my usual Saturday routine.  First I like to hit up Barracuda and grab brunch there.  For $9, you can drink as many mimosas as you can possibly handle in a hour and 30 minute window.  Afterwards, when I'm feeling nice and tipsy, I'll head over to Dolores Park where I'll bring some park supplies and chill with my group friends.  Dolores Park has a great view of the entire city and the park is usually filled with fun and unique individuals.  Make sure to look out for the guy selling rum filled coconuts!  He will open a coconut in front of you and pour in Captain Morgan into the coconut.  Best of all, he has a heavy pour!  \n If I feel like shopping a bit,  I'll hop on BART and go to Union Square. For dinner, I like to go grab ramen at Ramen Underground.  It can get pretty busy so be sure to allot 30 minutes before eating.  For night time activities, I'll head over to 1015 Folsom, which is a nightclub that will play trap heavy music.  1015 will bring some heavy hitting dj artists and the crowd is always lively and energetic.  This day is planned for individuals who love to eat and drink and party with friends"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    

    func setup() {
        textView.delegate = self
        textView.text = placeHolderText
        textView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePlan(_ sender: Any) {
        
        if textView.text != "" || textView.text == placeHolderText {
            delegate.getPlan(thePlan: textView.text)
            self.navigationController?.popViewController(animated: true)
            
        } else {
            //display alert message
        }
        
        
        
    }

}



extension WritePlanViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    
}

protocol WritePlanProtocol: NSObjectProtocol {
    func getPlan(thePlan: String)
}
