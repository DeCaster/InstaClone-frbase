//
//  FeedCell.swift
//  InstaClone-frbase
//
//  Created by Murad on 5.03.2024.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseFirestoreInternal
//UITableViewCell olusturmmiz gerek eger cell cubugu kullaniyorsak

class FeedCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButton(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text ?? "0") {
            let newLikeCount = likeCount + 1
            let likeStore = ["likes": newLikeCount]
            
            // Belirtilen belgeyi güncelle
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text ?? "").setData(likeStore, merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                    // Hata durumunda kullanıcıya bir hata mesajı göstermek için makeAlert fonksiyonunu kullanabilirsiniz.
                } else {
                    // Başarıyla güncellendiğinde görüntüyü tekrar yükle
                    DispatchQueue.main.async {
                        self.likeLabel.text = "\(newLikeCount)"
                    }
                }
            }
        }
    }

}
