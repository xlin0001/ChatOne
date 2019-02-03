//
//  ProfileTableViewController.swift
//  ChatOne
//
//  Created by 沈宇帆 on 28/1/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid == nil{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LogNavViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        loadAdminData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAdminData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0{
                do{
                    try Auth.auth().signOut()
                } catch let error{
                    print(error)
                }
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LogNavViewController
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    }
    
    func loadAdminData(){
        // Gets a FIRDatabaseReference for the provided URL.
        let refHandle = Database.database().reference(fromURL: "https://chatone-4ebde.firebaseio.com/")
        
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Loading Admin error occurs...")
            return
        }
        let currentUserRef = refHandle.child("users").child(userUID)
        // listen for data changes
        currentUserRef.observe(.value) { (snapshot) -> Void in
            print(snapshot)
            let userData = snapshot.value as! Dictionary<String, AnyObject>
            if let address = userData["address"],
                let name = userData["name"],
                let emailAddress = userData["emailAddress"],
                let bio = userData["bio"],
                let gender = userData["gender"],
                let url = userData["identityImageURL"]
            {
                self.emailText.text = emailAddress as? String
                let imgUrl = URL(string: url as! String)
                
                URLSession.shared.dataTask(with: imgUrl!, completionHandler: { (data, response, error) in
                    if error != nil {
                        // if download hits an error, so lets return out
                        print(error)
                        return
                    }
                    // if there is no error happens...
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                        self.profileImg.image = UIImage(data: data!)
                    }
                }).resume()
            }
            
        }
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
