//
//  ViewModel.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import Foundation
import SwiftUI
import Combine
class DataStoreViewModel: ObservableObject{
    
    var subsceiotins = Set<AnyCancellable>()
    
    var addStudent = PassthroughSubject<Student,Never>()
    var updateStudent = PassthroughSubject<Student,Never>()
    var deleteStudent = PassthroughSubject<IndexSet,Never>()
    var loadStudents = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    init() {
       // loadStudents()
        addSbscription()
   
        for student in students.value{
            emailes.append(student.email)
        }
        print(emailes)
        print(FileManager.docDirURL.path)
    }
    @Published var emailes = [String]()
   // @Published var students = [Student]()
    var students = CurrentValueSubject<[Student], Never>([])
    @Published var studentError : ErrorType? = nil
    func addSbscription(){
        addStudent
            .sink { [unowned self] student in
                students.value.append(student)
                self.objectWillChange.send()
            }
            .store(in: &subsceiotins)
        updateStudent
            .sink {[unowned self] student in
                guard let index = students.value.firstIndex(where: {$0.id == student.id})else{return}
                students.value[index] = student
                self.objectWillChange.send()
                
            }
            .store(in: &subsceiotins)
        
        deleteStudent
            .sink {[unowned self] indexSet in
                students.value.remove(atOffsets: indexSet)
                self.objectWillChange.send()
            }
            .store(in: &subsceiotins)
        
        loadStudents
            .filter{FileManager.default.fileExists(atPath: $0.path)}
            .tryMap{url in
                try Data(contentsOf: url)
            }
            .decode(type: [Student].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] completion in
                switch completion{
                case .finished:
                    print("data loaded")
                    studentSubscribtion()
                case .failure(let error):
                    if error is StudentError{
                        studentError = ErrorType(error: error as! StudentError)
                    }else{
                        studentError = ErrorType(error: .decodingError)
                        studentSubscribtion()
                    }
                }
            } receiveValue: { students in
                self.students.value = students
                self.objectWillChange.send()
            }
            .store(in: &subsceiotins)

        
    }
    func studentSubscribtion(){
        students
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap{data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink {[unowned self] completion in
                switch completion{
                case .finished:
                    print("student saved")
                case .failure(let error):
                    if error is StudentError{
                    studentError = ErrorType(error: error as! StudentError)
                    }else{
                        studentError = ErrorType(error: .encodingError)
                    }
                }
            } receiveValue: { _ in
                print("saved successfully")
            }
            .store(in: &subsceiotins)
    }

}
