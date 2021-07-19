//
//  StudentError.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import Foundation
enum StudentError : Error, LocalizedError {
    case saveStudentError
    case readStudentError
    case decodingError
    case encodingError
    
    var errorDiscription: String?{
        switch self{
        
        case .saveStudentError:
            return NSLocalizedString("could not save toDos, please reinstall the app", comment: "")
        case .readStudentError:
            return NSLocalizedString("could not load toDos, please reinstall the app", comment: "")
        case .decodingError:
            return NSLocalizedString("there was a problem loading your toDos, please create a new ToDo to start over", comment: "")
        case .encodingError:
            return NSLocalizedString("could not save toDos, please reinstall the app", comment: "")
        }
    }
}


struct ErrorType: Identifiable {
    var id = UUID()
    let error : StudentError
}
