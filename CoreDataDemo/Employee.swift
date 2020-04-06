//
//  Employee.swift
//  Demo1
//
//  Created by Jaydip's Mackbook on 02/04/20.
//  Copyright © 2020 Jaydip's Mackbook. All rights reserved.
//

import Foundation

class Employee: Codable {
    
    var intEmployeeId       :Int?
    var strProfilePic       :String?
    var strEmail            :String?
    var strFirst_name       :String?
    var strLast_name        :String?
    
    init(_ dic: [String:Any]) {
        intEmployeeId       = dic["id"] as? Int ?? 0
        strProfilePic       = dic["avatar"] as? String ?? ""
        strEmail            = dic["email"] as? String ?? ""
        strFirst_name       = dic["first_name"] as? String ?? ""
        strLast_name        = dic["last_name"] as? String ?? ""
    }
    
}
