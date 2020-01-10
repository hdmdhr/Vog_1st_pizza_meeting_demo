//
//  MyMasterVC.swift
//  Vog_1st_pizza_meeting_demo
//
//  Created by DongMing on 2020-01-09.
//  Copyright © 2020 VogDevelopers. All rights reserved.
//

import UIKit
import MessageUI


class MyMasterVC: UIViewController {
    
    // MARK: - IBOutlets, Props
    
    @IBOutlet weak var table: ContentSizedTableView!
    @IBOutlet weak var tableHeaderTextView: UITextView!
    
    var dates = [NSDate]()
    
    // MARK: - Lifecycles, Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        table.rowHeight = 80
                
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        // FIXME: - set link to TextView attributed string here
        
    }
    
    // code to make tableHeaderView, tableFooterView height dynamic
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let headerView = table.tableHeaderView else { return }
        let minSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != minSize.height {
            headerView.frame.size.height = minSize.height
            table.tableHeaderView = headerView
        }
        
        guard let footerView = table.tableFooterView else { return }
        let minFooterSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if footerView.frame.height != minFooterSize.height {
            footerView.frame.size.height = minFooterSize.height
            table.tableFooterView = footerView
        }
    }
    

    @objc func insertNewObject(_ sender: Any) {
        dates.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showingDetail" {
            if let indexPath = table.indexPathForSelectedRow {
                let date = dates[indexPath.row]
                let detailVC = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                detailVC.detailItem = date
                detailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                detailVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}

// MARK: - Table DataSource, Delegate

extension MyMasterVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = dates[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showingDetail", sender: self)
    }
}

// MARK: - Email, Phone call

extension MyMasterVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func sendEmail(to address: String, withSubject subject: String="Bug Report", withMessage message: String="Hello Developer, ") {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([address])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(message, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Please check your email setting", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func makePhoneCall(to phoneNumber:String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
}
