//
//  UploadViewController.swift
//  InstaClone-frbase
//
//  Created by Murad on 2.03.2024.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Görüntüye dokunmayı algılamak için kullanıcı etkileşimi etkinleştirilir.
        imageView.isUserInteractionEnabled = true
        
        // Görüntüye bir dokunma tanımlayıcı eklenir.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    // Kullanıcı bir resim seçmek için görüntüye dokunduğunda çağrılır.
    @objc func chooseImage() {
        // Resim seçiciyi oluşturur.
        let pickerController = UIImagePickerController()
        // Resim seçiciyi bu sınıfın bir örneği olarak ayarlar.
        pickerController.delegate = self
        // Resim seçicinin kaynak türünü fotoğraf kütüphanesi olarak ayarlar.
        pickerController.sourceType = .photoLibrary
        // Resim seçiciyi ekranda gösterir.
        present(pickerController, animated: true, completion: nil)
    }
    
    // Kullanıcı bir resmi seçtiğinde çağrılır.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Seçilen resmi görüntü görüntüsüne atar.
        imageView.image = info[.originalImage] as? UIImage
        // Resim seçiciyi kapatır.
        self.dismiss(animated: true, completion: nil)
    }
    
    // Başka bir eylem butonuna tıklanırsa çağrılır.
    @IBAction func actionButtonClicked(_ sender: Any) {
        // Firebase Storage'a erişmek için bir depolama referansı oluşturulur
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        // Depolama referansı içinde bir alt klasör belirlenir
        let mediaFolder = storageReference.child("media")
        
        // Eğer imageView içinde bir resim varsa, veriyi al
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            // Resmin adı için benzersiz bir UUID oluştur
            let uuid = UUID().uuidString
            // Resmin depolama yolu belirlenir ve veri yüklenir
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                // Yükleme işlemi tamamlandıktan sonra çalışacak kapanış ifadesi
                if error != nil {
                    // Hata varsa kullanıcıya bir hata mesajı göster
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                } else {
                    // Yükleme başarılıysa, resmin indirme URL'sini al
                    imageReference.downloadURL() { (url, error) in
                        if error == nil {
                            // Indirme URL'sini al
                            let imageUrl = url?.absoluteString
                            
                            // Firestore veritabanına resim ve ilgili bilgileri kaydet
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            let firestorePost = [
                                "imageUrl": imageUrl!,
                                "postedBy": Auth.auth().currentUser!.email!,
                                "postComment": self.commentText.text!,
                                "date": FieldValue.serverTimestamp(),
                                "likes": 0,
                            ]
                            // "Posts" koleksiyonuna belirtilen verileri ekle
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost) { error in
                                if error != nil {
                                    // Hata varsa kullanıcıya bir hata mesajı göster
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                                } else {
                                    // Başarıyla yükleme yapıldı, imageView ve commentText'i sıfırla
                                    self.imageView.image = UIImage(named: "selectt.png")
                                    self.commentText.text = ""
                                    // TabBarController'da ilk sekmesi seç
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Alert oluşturma fonksiyonu
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        // OK butonu ekle
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        // Alert'e OK butonunu ekle
        alert.addAction(okButton)
        // Alert'i görüntüle
        self.present(alert,animated: true,completion: nil)
    }
}
