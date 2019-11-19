//
//  MyNotesTableViewController.swift
//  MyNotes
//
//  Created by Roy, Bishakha on 11/19/19.
//  Copyright © 2019 Roy, Bishakha. All rights reserved.
//

import UIKit
import CoreData

class MyNotesTableViewController: UITableViewController {

    // create a refernce to a context
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    var MyNotes = [Notes] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()

        // make row height larger
        self.tableView.rowHeight = 84.0


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // fetch ShoppingLists from Core Data
       func loadNotes() {
           
           // create an instance of a FetchRequest so that
           // ShoppingLists can be fetched from Core Data
           let request: NSFetchRequest<Notes> =
           Notes.fetchRequest()
           
           do {
               // use context to execute a fetch request
               // to fetch ShoppingLists from Core Data
               // store the fetched ShoppingLists in our array
               MyNotes = try context.fetch(request)
           } catch {
               print("Error fetching Notes from Core Data!")
           }
           
           // reload the fetched data in the Table AView Controller
           tableView.reloadData()
       }
       
       // save ShoppingList
       func saveNotes () {
           do {
               // use context to save ShoppingLists
               try context.save()
           }catch {
               print("Error saving Notes to Core Data!")
           }
           // reload the data in the Table View Controller
           tableView.reloadData()
       }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // declare Text Fields variables for the input of the title, type, and date
        var titleTextfeild = UITextField()
        var typeTextfeild = UITextField()
        var dateTextfeild = UITextField()
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        
        // create an Alert Controller
        let alert = UIAlertController(title: "Add Notes", message: "", preferredStyle: .alert)
                             
        // define an action that will occur when the Add List button is pushed
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
                                 
        // create an instance of a ShoppingList entity
        let newNotes = Notes(context: self.context)
                                 
       // get name, store, and date input by user and store them in the ShoppingList entity
            newNotes.title = titleTextfeild.text!
            newNotes.type = typeTextfeild.text!
            newNotes.date = dateTextfeild.text!
           
        // add ShoppingListItem entity into array
        self.MyNotes.append(newNotes)
                                 
        // save ShoppingLists into Core Data
        self.saveNotes()
                                 
                             })
                             
                             // disable the action that will occure whe the Add List button is pushed
                             action.isEnabled = false
                             
                             // define an action that will occure when the Cancel is pushed
                             let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
                                 
                             })
                             
                             // add actions into Alert Controller
                             alert.addAction(action)
                             alert.addAction(cancelAction)
                             
                             // add the Text fields into the Alert Controller
                             alert.addTextField(configurationHandler: { (field) in
                                 titleTextfeild = field
                                 titleTextfeild.placeholder = "Title"
                                 titleTextfeild.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
                             })
                             alert.addTextField(configurationHandler: { (field) in
                                 typeTextfeild = field
                                 typeTextfeild.placeholder = "Type"
                                 typeTextfeild.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
                             })
                             alert.addTextField(configurationHandler: { (field) in
                                 dateTextfeild = field
                                 dateTextfeild.placeholder = "Date"
                                 dateTextfeild.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
                             })
        
                             
                             // display the Alert Controller
                             present(alert, animated: true, completion: nil)
                  }
           
               @objc func alertTextFieldDidChange () {
               
               // get a refernce to the Alert Controller
               let alertController = self.presentedViewController as!
                   UIAlertController
               
               // get a refernce to the action that allows the user to add a ShoppingList
               let action = alertController.actions[0]
               
               // get refernce to the text in the Text Fields
               if let title = alertController.textFields![0].text,
                   let type = alertController.textFields![1].text,
                let date = alertController.textFields![2].text{
                   
                   // trim whitespaces from the text
                   let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
                   let trimmedType = type.trimmingCharacters(in: .whitespaces)
                   let trimmedDate = date.trimmingCharacters(in: .whitespaces)
                   
                   
                   //check if the trimmed text isn't empty and if it isn't enable the action that allows the user to add ShoppingList
                   if (!trimmedTitle.isEmpty && !trimmedType.isEmpty && !trimmedDate.isEmpty ){
                       action.isEnabled = true
                   }
           }
}

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MyNotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotesCell", for: indexPath)

        // Configure the cell...
       let MyNote = MyNotes[indexPath.row]
              cell.textLabel?.text = MyNote.title!
              cell.detailTextLabel?.text = MyNote.type! + " " +
              MyNote.date!



        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
