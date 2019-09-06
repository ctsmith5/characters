//
//  CharacterTableViewController.swift
//  TheSimpsons
//
//  Created by Colin Smith on 9/5/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class CharacterTableViewController: UITableViewController {
    
    fileprivate var collapseDetailViewController = true

    var characters: [CSCharacter] = []
    
    weak var delegate: CharacterSelectionDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        // IF Bundle is Simpsons
        #if WIRE
        wire()
        #else
        // If Bundle is Wire
        simpsons()
        #endif
    }

    func simpsons(){
        ViewModel.shared.fetchSimpsons { (simpsons) in
            self.characters = simpsons
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func wire() {
        ViewModel.shared.fetchWire { (wire) in
            self.characters = wire
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source
    
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.characters.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)

        cell.textLabel?.text = self.characters[indexPath.row].name

        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.row]
        delegate?.characterSelected(selectedCharacter)
        if let detailViewController = delegate as? CharacterViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        collapseDetailViewController = false
    }
 
    
    
}


extension CharacterTableViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}
