//
//  mainTableViewController.swift
//  listApp
//
//  Created by Emily on 2/1/18.
//  Copyright © 2018 Emily. All rights reserved.
//

import UIKit
import CoreData

class mainTableViewController: UITableViewController, ViewControllerDelegate {
    
    
    func savelist(by controller: secondViewController, firstName: String, lastName: String, phone: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let item = tasks[ip.row]
            item.firstName = firstName
            item.lastName = lastName
            item.phone = phone
        }
            
        else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "Info", into: managedObjectContext) as! Info
            item.firstName = firstName
            item.lastName = lastName
            item.phone = phone
            tasks.append(item)
        }
        
        do{
            try managedObjectContext.save()
        }
        catch{
            print("\(error)")
        }
        dismiss(animated: true, completion: nil)
        fetchAllItems()
        tableView.reloadData()
    }
    
    
    var tasks = [Info]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        fetchAllItems()
        tableView.reloadData()
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func fetchAllItems(){
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Info")
        do {
            let results = try managedObjectContext.fetch(itemRequest)
            tasks = results as! [Info]
          
        } catch {
            print("\(error)")
        }

        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let controller = navigationController.topViewController as! secondViewController
        controller.delegate = self
    }
    
    //************************* populate the task ************************************
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        
        let item = tasks[indexPath.row]
        cell.textLabel?.text = item.firstName
        cell.detailTextLabel?.text = item.phone
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Action Sheet", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Send now", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
        
    }

}



