//
//  CreatorViewController.swift
//  PrintHTML2PDF
//
//  Created by User on 11/20/19.
//  Copyright © 2019 Aloha. All rights reserved.
//

import UIKit

class CreatorViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var tblInvoiceItems: UITableView!
    
    @IBOutlet weak var bbiTotal: UIBarButtonItem!
    
    @IBOutlet weak var tvRecipientInfo: UITextView!
   
    @IBOutlet weak var text1label: UITextField!
    
    @IBOutlet weak var text2label: UITextField!
    
    @IBOutlet weak var text3label: UITextField!
    
    // MARK: - Declaration
    var items: [String: String]?
    var saveCompletionHandler: ((_ tvRecipientInfo: String, _ text1label: String, _ text2label: String, _ text3label: String) -> Void)!
    
    
    // MARK: - view lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

      // MARK: Custom Methods
      func presentCreatorViewControllerInViewController(originalViewController: UIViewController, saveCompletionHandler: @escaping (_ tvRecipientInfo: String, _ text1label: String, _ text2label: String, _ text3label: String) -> Void) {
          self.saveCompletionHandler = saveCompletionHandler
          originalViewController.navigationController?.pushViewController(self, animated: true)
      }
      
    
    
    // MARK: IBAction Methods
    @IBAction func saveInvoice(_ sender: AnyObject) {
        if saveCompletionHandler != nil {
            saveCompletionHandler(_: tvRecipientInfo.text ?? "nil", _: text1label.text ?? "nil", _: text2label.text ?? "nil", _: text3label.text ?? "nil")
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: IBAction Methods
    @objc func dismissKeyboard() {
        if tvRecipientInfo.isFirstResponder {
            tvRecipientInfo.resignFirstResponder()
        }
    }
   
}
