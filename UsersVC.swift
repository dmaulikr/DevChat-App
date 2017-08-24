//
//  UsersVC.swift
//  DevChat
//
//  Created by Mark Price on 7/15/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    
    private var _snapData: Data?
    private var _videoURL: URL?
    
    var snapData: Data? {
        set {
            _snapData = newValue
        } get {
            return _snapData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        } get {
            return _videoURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    

    @IBAction func sendPRBtnPressed(sender: AnyObject) {
        
        if let url = _videoURL {
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            _ = ref.putFile(url, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:NSError?) in
                
                if err != nil {
                    print("Error uploading video: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    DataService.instance.sendMediaPullRequest(senderUID: FIRAuth.auth()!.currentUser!.uid, sendingTo: self.selectedUsers, mediaURL: downloadURL!, textSnippet: "Coding today was LEGIT!")
                    print("Download URL: \(downloadURL)")
                    //save this somewhere
                    
                }
                
            } as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void as! (FIRStorageMetadata?, Error?) -> Void)
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            let ref = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            
            _ = ref.put(snap, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:NSError?) in
                
                if err != nil {
                    print("Error uploading snapshot: \(err?.localizedDescription)")
                } else {
                    let downloadURL = meta!.downloadURL()
                    self.dismiss(animated: true, completion: nil)
                }
            } as! (FIRStorageMetadata?, Error?) -> Void)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
