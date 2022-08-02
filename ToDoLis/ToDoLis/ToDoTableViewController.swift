//
//  ToDoTableViewController.swift
//  ToDoLis
//
//  Created by Mark Cheng on 7/27/20.
//  Copyright © 2020 KWK. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {

    var listOfToDo : [ToDoCD] = []
    
     /*func createToDo() -> [ToDoClass] {

         let swiftToDo = ToDoClass()
         swiftToDo.description = "Learn Swift"
         swiftToDo.important = true

         let dogToDo = ToDoClass()
         dogToDo.description = "Walk the Dog"
         // important is set to false by default

         return [swiftToDo, dogToDo]
    }
*/

    func getToDos(){
        if let acccessToCoreData = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let dataFromCoreData = try? acccessToCoreData.fetch(ToDoCD.fetchRequest())as? [ToDoCD]
            {
                listOfToDo = dataFromCoreData
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // listOfToDo = createToDo()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfToDo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let eachToDo = listOfToDo[indexPath.row]

        if let thereIsDescription = eachToDo.descriptionInCD{
            if eachToDo.importantInCD {
                cell.textLabel?.text = "❗️" + thereIsDescription
            } else {
                cell.textLabel?.text = eachToDo.descriptionInCD
            }
            
        }



        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        getToDos()  
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         // this gives us a single ToDo
         let eachToDo = listOfToDo[indexPath.row]

         performSegue(withIdentifier: "moveToCompletedToDoVC", sender: eachToDo)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextAddToDoVC = segue.destination as? AddToDoViewController {
            nextAddToDoVC.previousToDoTVC = self
        }
        
        if let nextCompletedToDoVC = segue.destination as? CompletedToDoViewController {
                 if let choosenToDo = sender as? ToDoCD {
                      nextCompletedToDoVC.selectedToDo = choosenToDo
                      nextCompletedToDoVC.previousToDoTVC = self
                 }
        }

    }
    

}
