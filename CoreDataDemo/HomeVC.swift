//
//  HomeVC.swift
//  Demo1
//
//  Created by Jaydip's Mackbook on 01/04/20.
//  Copyright © 2020 Jaydip's Mackbook. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var arrEmployee = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.estimatedRowHeight = 100
        tblView.rowHeight = UITableView.automaticDimension
        fetchData()
    }
    
    func getData(){
        var request = URLRequest(url: URL(string: "https://reqres.in/api/users?page=1")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                print(json)
                DispatchQueue.main.async {
                    if let data = json["data"] as? [[String:Any]]{
                        for obj in data{
                            let objEmployee = Employee.init(obj)
                            self.arrEmployee.append(objEmployee)
                            self.tblView.reloadData()
                            CoreDataManager.shared.saveUserData(tblName: "Employees") { (result) in
                                result.setValue(objEmployee.strProfilePic ?? "", forKey: "avatar")
                                result.setValue(objEmployee.strFirst_name ?? "", forKey: "first_name")
                                result.setValue(objEmployee.strLast_name ?? "", forKey:  "last_name")
                                result.setValue(objEmployee.strEmail ?? "", forKey: "email")
                                result.setValue(objEmployee.intEmployeeId ?? 0, forKey: "id")
                            }
                        }
                        CoreDataManager.shared.save()
                    }
                }
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    
    func fetchData(){
//        CoreDataManager.shared.deleteAllData("Employees")
        
        CoreDataManager.shared.fetchData(tblName: "Employees") { (isFetch, data) in
            if isFetch {
                if (data as? [[String:Any]])?.count ?? 0 > 0 {
                    for obj in data as? [[String:Any]] ?? []{
                        let objEmployee = Employee.init(obj)
                        self.arrEmployee.append(objEmployee)
                        self.tblView.reloadData()
                    }
                }else{
                    self.getData()
                }
            }else{
                self.getData()
            }
        }
    }
}

//MARK: UITablview delegate
extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "HomeTCell") as! HomeTCell
        let obj = arrEmployee[indexPath.row]
        cell.lblName.text = "\(obj.strFirst_name ?? "") \(obj.strLast_name ?? "")"
        cell.imgProile.downloaded(from: obj.strProfilePic ?? "", contentMode: UIView.ContentMode.scaleAspectFit)
        return cell
    }
}

//MARK: UITablviewCell
class HomeTCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProile: UIImageView!
    
    override func awakeFromNib() {
        imgProile.layer.cornerRadius = imgProile.frame.size.width/2
        imgProile.layer.borderWidth = 2
        imgProile.layer.borderColor = UIColor.blue.cgColor
        imgProile.clipsToBounds = true
    }
}
