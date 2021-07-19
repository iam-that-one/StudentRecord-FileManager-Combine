//
//  ModalType.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import Foundation
import SwiftUI

enum ModelType: Identifiable,View {
    case new
    case update(Student)
    
    var id : String{
        switch self{
        case .new:
            return "new"
        case .update:
            return "update"
        
        }
    }
    var body: some View{
        switch self{
        case .new:
            return StudentFormView(SFVm: StudentFormViewModel())
        case .update(let student):
            return StudentFormView(SFVm: StudentFormViewModel(student: student))
    
        }
    }
    

}
