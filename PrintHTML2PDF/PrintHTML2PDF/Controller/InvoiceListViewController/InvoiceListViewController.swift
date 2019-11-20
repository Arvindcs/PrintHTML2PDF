//
//  InvoiceListViewController.swift
//  PrintHTML2PDF
//
//  Created by User on 11/20/19.
//  Copyright © 2019 Aloha. All rights reserved.
//

import UIKit

class InvoiceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tblInvoices: UITableView!
    
    
    var invoices: [[String: Any]]!
    
    var selectedInvoiceIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblInvoices.delegate = self
        tblInvoices.dataSource = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let inv = UserDefaults.standard.object(forKey: "invoices") {
            invoices = inv as? [[String: Any]]
            tblInvoices.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBAction Methods
    @IBAction func CreateInvoiceButtonPressed(_ sender: UIBarButtonItem) {
        let creatorViewController = storyboard?.instantiateViewController(withIdentifier: "idCreateInvoice") as! CreatorViewController
               creatorViewController.presentCreatorViewControllerInViewController(originalViewController: self) { (recipientInfo, label1, label2, label3) in
                   DispatchQueue.main.async {
                       if self.invoices == nil {
                           self.invoices = [[String: AnyObject]]()
                       }
                       // Add the new invoice data to the invoices array.
                        self.invoices.append(["recipientInfo": recipientInfo, "label1":  label1, "label2": label2, "label3": label3])
                       // Update the user defaults with the new invoice.
                       UserDefaults.standard.set(self.invoices, forKey: "invoices")
                       // Reload the tableview.
                       self.tblInvoices.reloadData()
                   }
               }
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (invoices != nil) ? invoices.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath as IndexPath)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "invoiceCell")
        }
        
        cell.textLabel?.text = "\(invoices[indexPath.row]["recipientInfo"] as! String) - \(invoices[indexPath.row]["label1"] as! String) - \(invoices[indexPath.row]["label2"] as! String)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewViewController = self.storyboard?.instantiateViewController(identifier: "PreviewViewControllerId") as! PreviewViewController
        previewViewController.invoiceInfo = invoices[indexPath.row]
        self.navigationController?.pushViewController(previewViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            invoices.remove(at: indexPath.row)
            tblInvoices.reloadData()
            UserDefaults.standard.set(self.invoices, forKey: "invoices")
        }
    }
    
    
}
