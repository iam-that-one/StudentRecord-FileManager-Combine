//
//  Students.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import Foundation

struct Student : Identifiable, Codable {
    var id = UUID().uuidString
    var name : String
    var school : String
    var address : String
    var email : String
    var phone : String
    
    
    static var sampel : [Student] {
        [
            Student(id: UUID().uuidString, name: "Abdullah", school: "Alyamamah",address: "",email: "",phone: "")
        ]
    }
}
