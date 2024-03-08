//
//  FeedViewController.swift
//  InstaClone-frbase
//
//  Created by Murad on 2.03.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tablo görünümünün veri kaynağı ve delegesi olarak bu sınıfı ayarla
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func getDataFromFirestore (){
        let fireStoreDatabase = Firestore.firestore()
//        let settings = fireStoreDatabase.settings
//        settings.areTimestampsInSnapshotsEnabled = true
//        fireStoreDatabase.settings = settings
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        print(documentID)
                        
                        if let postedBY = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBY)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
               
            }
        }
    }
    
    // Tablo görünümünde kaç satır olacağını belirten fonksiyon
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count // Örnek olarak 10 satır döndürüyoruz
    }
    
    // Tablo hücresini oluşturan ve yapılandıran fonksiyon
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Yeniden kullanılabilir bir hücre al
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        // Hücrenin bileşenlerini doldur
        cell.userEmailLabel.text! = userEmailArray[indexPath.row] // Kullanıcı e-posta etiketi
        cell.likeLabel.text! = String(likeArray[indexPath.row]) // Beğeni sayısı etiketi
        cell.commentLabel.text! = userCommentArray[indexPath.row] // Yorum etiketi
        cell.userImageView.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell // Doldurulan hücreyi dön
    }
}

