//
//  UserInfoTableViewController.swift
//  ChatOne
//
//  Created by 沈宇帆 on 1/2/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class UserInfoTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
   
    

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var addText: UITextField!
    @IBOutlet weak var bioText: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    private var gender = ["female","male"]
    private var picker = UIPickerView()
    private var pickerAccessoryBar: UIToolbar = {
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dissmissKeyBoard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        picker.delegate = self
        picker.dataSource = self
        genderText.inputView = picker
        genderText.inputAccessoryView = pickerAccessoryBar
        loadAdminData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func saveInfo(_ sender: Any) {
        // upload the user image.
        let storageRef = Storage.storage().reference().child("AdminIdentityImages").child(NSUUID().uuidString)
        
        // Create file metadata to update
        let newMetadata = StorageMetadata()
        newMetadata.cacheControl = "public,max-age=300";
        newMetadata.contentType = "image/jpeg";
        
        if let uploadData = (self.profileImage.image!).pngData(){
            storageRef.putData(uploadData, metadata: newMetadata, completion: { (metadata, errorForUpload) in
                // if uploading has errors
                if errorForUpload != nil {
                    print(errorForUpload)
                    return
                }
                // if successfully upload, get the absolute url
                //                    if let identityImageURL = metadata?.downloadURL().absoluteString {
                //                        print(identityImageURL)
                //                    }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    if let identityImageURL = url?.absoluteString{
                        let values = ["name": self.nameText.text, "gender": self.genderText.text,"address":self.addText.text,"bio":self.bioText.text, "identityImageURL": identityImageURL] as [String : Any]
                        self.handleUpdateAdminInfo(values as [String : AnyObject])
                    }
                })
                
            })
        }
         navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Source Type", message: "Choose where the image is from", preferredStyle: .actionSheet)
        //action in the actionSheet that handles the logic of choosing photos in the photo library...
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction!) -> Void in
            let controller = UIImagePickerController()
            
            controller.sourceType = .photoLibrary
            // not allow editing after selecting the file...
            controller.allowsEditing = true
            controller.delegate = self
            //Presents a view controller modally.
            self.present(controller, animated: true, completion: nil)
        }))
        // action in the actionSheet that handles the logic of taking a new photo...
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction!) -> Void in
            // not available of camera
            // the emulator does not support the support the camera...
            if !UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerController.SourceType.camera) {
                //show the alert controller that the camera is not available...
                let cameraNotAvailableAlertController = UIAlertController(title: "The camera is not available", message: "It seems like this device has no camera", preferredStyle: .alert)
                cameraNotAvailableAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(cameraNotAvailableAlertController, animated: true, completion: nil)
                
            }
                //available of camera
            else {
                let controller = UIImagePickerController()
                controller.sourceType = .camera
                controller.allowsEditing = false
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }))
        // cancel the action...
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.profileImage.image = pickedImage
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderText.text = gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    @objc func dissmissKeyBoard(){
        view.endEditing(true)
    }
    //update the user information
    func handleUpdateAdminInfo(_ values: [String: AnyObject]){
        let refHandle = Database.database().reference(fromURL: "https://chatone-4ebde.firebaseio.com/")
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Update error occurs...")
            return
        }
        let currentUserRef = refHandle.child("users").child(userUID)
        // Updates the values at the specified paths in the dictionary without overwriting other keys at this location.
        currentUserRef.updateChildValues(values)
        
    }
    
    // load this administration data from firebase auth.
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
                let bio = userData["bio"],
                let gender = userData["gender"],
                let url = userData["identityImageURL"]
            {
                self.nameText.text = name as? String
                self.addText.text = address as? String
                self.bioText.text = bio as? String
                self.genderText.text = gender as? String
                let imgUrl = URL(string: url as! String)
                
                URLSession.shared.dataTask(with: imgUrl!, completionHandler: { (data, response, error) in
                    if error != nil {
                        // if download hits an error, so lets return out
                        print(error)
                        return
                    }
                    // if there is no error happens...
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // in half a second...
                        self.profileImage.image = UIImage(data: data!)
                    }
                }).resume()
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
        return 5
    }

    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
