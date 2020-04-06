//
//  ViewController.swift
//  Demo1
//
//  Created by Jaydip's Mackbook on 30/03/20.
//  Copyright © 2020 Jaydip's Mackbook. All rights reserved.
//

import UIKit
import CoreData

struct UserData {
    var profilePic: Data?
    var strName: String?
    var strEmail: String?
    var strMobile: String?
    var strDegree: String?
    var strPassword: String?
    var strDesc: String?
}

class RegisterVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtdegree: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    var userData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.text = ""
        textView.delegate = self
        textViewHeightChange(textView)
        textView.contentInset = UIEdgeInsets.init(top: 40, left: 0, bottom: 20, right: 20)
       
    }
   
    //MARK: Other Function
    func textViewHeightChange(_ textView: UITextView){
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        textViewHeight.constant = newSize.height
    }
    
    //MARK:- Action
    @IBAction func btnProfilePicTapped(_ sender: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = .photoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
    @IBAction func btnSubmitTappedTapped(_ sender: UIButton){

        userData.strName = txtName.text
        userData.strEmail = txtEmail.text
        userData.strMobile = txtMobile.text
        userData.strDegree = txtdegree.text
        userData.strPassword = txtpassword.text
        userData.strDesc = textView.text
        
        CoreDataManager.shared.saveUserData(tblName: "TblSignUp") { (data) in
            
            data.setValue(self.userData.profilePic, forKey: "profilepic")
            data.setValue(self.userData.strName, forKey: "name")
            data.setValue(self.userData.strEmail, forKey: "email")
            data.setValue(self.userData.strMobile, forKey: "mobileno")
            data.setValue(self.userData.strDegree, forKey: "degree")
            data.setValue(self.userData.strPassword, forKey: "password")
            data.setValue(self.userData.strDesc, forKey: "desc")

            CoreDataManager.shared.save()
        }
    }
    
    @IBAction func btnGetDataTapped(_ sender: UIButton){
        CoreDataManager.shared.fetchData(tblName: "TblSignUp") { (isFetch, data) in
            if isFetch {
                for obj in data as? [[String:Any]] ?? []{
                    print(obj["name"] as? String ?? "" )
                    let imgData = obj["profilepic"] as? Data ?? Data()
                    self.btnProfilePic.setImage(UIImage.init(data: imgData), for: .normal)
                }
            }
        }
    }
    @IBAction func btnDeleteTapped(_ sender: UIButton){
        
        CoreDataManager.shared.deleteAllData("TblSignUp")
        //CoreDataManager.shared.deleteSpecificRecord(tblName: "TblSignUp", kName: "name", kValue: "Jaydip Savaliya")
    }
    
    //MARK: TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        self.textViewHeightChange(textView)
    }
}

//MARK:- ImagePicker Delegate
extension RegisterVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            btnProfilePic.setImage(image, for: .normal)
            let data = prepareImageForSaving(image: image) ?? Data()
            userData.profilePic = data
        } else {
            print("Other source")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


