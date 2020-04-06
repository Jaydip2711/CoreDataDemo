//
//  LogInVC.swift
//  Demo1
//
//  Created by Jaydip's Mackbook on 01/04/20.
//  Copyright © 2020 Jaydip's Mackbook. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogInTapped(_ sender: UIButton){
        
        
//        let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let homeVC = StoryBoard.instantiateViewController(identifier: "HomeVC") as! HomeVC
//        self.navigationController?.pushViewController(homeVC, animated:true)
        
        var isLogin = false
        CoreDataManager.shared.fetchData(tblName: "TblSignUp") { (isFetch, data) in
            if isFetch {
                for obj in data as? [[String:Any]] ?? []{
                    print(obj["name"] as? String ?? "" )
                    isLogin = false
                    if self.txtEmail.text == obj["email"] as? String ?? "" && self.txtPassword.text == obj["password"] as? String ?? ""{
                        isLogin = true
                        break
                    }
                }
            }
        }
        if isLogin{
            let StoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeVC = StoryBoard.instantiateViewController(identifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(homeVC, animated:true)
        }else{
            print("Login Faild.")
        }
    }
}
