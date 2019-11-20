//
//  InvoiceComposer.swift
//  PrintHTML2PDF
//
//  Created by User on 11/20/19.
//  Copyright © 2019 Aloha. All rights reserved.
//

import UIKit

class InvoiceComposer: NSObject {

    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "invoice", ofType: "html")
    
    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
    
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")
    
    let senderInfo = "Arvind Patel, Vishal Nagar, Pune, Maharashtra, Pincode - 411027"
    
    let dueDate = "20-11-2019"
    
    let paymentMethod = "Paytm Transfer"
    
    let logoImageURL = "https://icon-library.net/images/person-icon-outline/person-icon-outline-1.jpg"
    
    var invoiceNumber: String!
    
    var pdfFilename: String!
    
    
    override init() {
        super.init()
    }
    
    

    func renderInvoice(recipientInfo: String, label1: String, label2: String, label3: String) -> String! {
        // Store the invoice number for future use.
        self.invoiceNumber = label1
        
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            // The logo image.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO_IMAGE#", with: logoImageURL)
            
            // Invoice number.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#recipientInfo#", with: invoiceNumber)
            
            // Invoice date.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#LABEL_1#", with: label1)
            
            // Due date (we leave it blank by default).
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DUE_DATE#", with: dueDate)
            
            // Sender info.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: senderInfo)
            
            // Recipient info.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: recipientInfo.replacingOccurrences(of: "\n", with: "<br>"))
            
            // Payment method.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PAYMENT_METHOD#", with: paymentMethod)
            
            // Total amount.
            //  HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: totalAmount)
            
            // The invoice items will be added by using a loop.
            var allItems = ""
            
            let items: [[String: String]] =  [["item": label1],["item": label2],["item": label3]]
            
            for i in 0..<items.count {
                var itemHTMLContent: String!
                
                // Determine the proper template file.
             //   if i != items.count - 1 {
                    itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
            //    }
            //    else {
            //        itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
            //    }
                
                // Replace the description and price placeholders with the actual values.
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#", with: items[i]["item"]!)
                
                // Format each item's price as a currency value.

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: "50/-")
                
                // Add the item's HTML code to the general items string.
                allItems += itemHTMLContent
            }
            
            // Set the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            // The HTML code is ready.
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/Invoice\(invoiceNumber!).pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename ?? "")
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}
