//
//  ItemsViewController.swift
//  Homeowner
//
//  Created by Jonathan Lace on 4/11/16.
//  Copyright © 2016 SHP. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
//Properties
    
    var itemStore: ItemStore!
    

    
//Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
       tableView.rowHeight = 65
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        
        //Make a new index path for the 0th section, last row
        //let lastRow = tableView.numberOfRowsInSection(0)
        //let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
        
        //Insert this new row into the table
       // tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        
        if editing {
            
            //Change text of button to inform user of state
            sender.setTitle("Edit", forState: .Normal)
            
            
            //Determines whether or not the view is currently editable
            setEditing(false, animated: true)
            
        } else {
            
            //Change text of button to inform user of state
            sender.setTitle("Done", forState: .Normal)
            
            //Determines whether or not the view is currently editable
            setEditing(true, animated: true)
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        //update the label for dynamic type
        cell.updateLabels()
        
        
        let item = itemStore.allItems[indexPath.row]
        
        //cell.textLabel?.text = item.name
        //cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        //Configure the cell with the Item
        cell.nameLabel.text  = item.name
        cell.serialNumber.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell

    }
    
    
   
    override func tableView(tableView:UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //If the table view is asking to commit a delete command...
        if editingStyle == .Delete {
            
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:nil)
             ac.addAction(cancelAction)
            
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            
        
                //Remove item from the store
                self.itemStore.removeItem(item)
            
                //Also remove that row from teh table view with an animation
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)})
            
            ac.addAction(deleteAction)
            
            //Present the alert controller to the itemsViewController
            presentViewController(ac, animated: true, completion: nil)
        
        }
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        //update the model
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //If the triggered segue is the ShowItem segue
        if segue.identifier == "ShowItem" {
            
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
            }
        
        }
    
    
    }
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
}
