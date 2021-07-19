//
//  StudentFormViewModel.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import Foundation
import SwiftUI

class StudentFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var school = ""
    @Published var address = ""
    @Published var email = ""
    @Published var phone = ""
    var id : String?
    var isUpdating: Bool{
        id != nil
    }
    
    var isDisabled : Bool{
        name.isEmpty
    }
    init() {}
    
    init(student : Student) {
        name = student.name
        school = student.school
        address = student.address
        email = student.email
        phone = student.phone
        id = student.id
        
    }
    
}
