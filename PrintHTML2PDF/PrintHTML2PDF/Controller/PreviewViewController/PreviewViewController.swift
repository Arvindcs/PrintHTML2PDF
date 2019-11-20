//
//  PreviewViewController.swift
//  PrintHTML2PDF
//
//  Created by User on 11/20/19.
//  Copyright © 2019 Aloha. All rights reserved.
//

import UIKit
import MessageUI
import WebKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var webPreview: UIWebView!
    
    var invoiceInfo: [String: Any]!
    
    var invoiceComposer: InvoiceComposer!
    
    var HTMLContent: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createInvoiceAsHTML()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: IBAction Methods
    @IBAction func exportToPDF(_ sender: AnyObject) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
  
    // MARK: Custom Methods
    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
       
        if let invoiceHTML = invoiceComposer.renderInvoice(recipientInfo: invoiceInfo["recipientInfo"] as? String ?? "nil",
                                                           label1: invoiceInfo["label1"] as? String ?? "nil",
                                                           label2: invoiceInfo["label2"] as? String ?? "nil",
                                                           label3: invoiceInfo["label3"] as? String ?? "nil") {
            
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertController.Style.alert)
        
          let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertAction.Style.default) { (action) in
                  if let filename = self.invoiceComposer.pdfFilename, let url = URL(string: filename) {
                      let request = URLRequest(url: url)
                      self.webPreview.loadRequest(request)
                  }
              }
        
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertAction.Style.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Nothing", style: UIAlertAction.Style.default) { (action) in
            
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: invoiceComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
}
