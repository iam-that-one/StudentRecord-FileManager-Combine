//
//  FileManeger.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import Foundation

let fileName = "studentsRecord.json"

extension FileManager{
    static var docDirURL : URL{
        Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveDocument(content: String, docName: String, completion: (StudentError?) -> Void){
        let url = Self.docDirURL.appendingPathComponent(docName)
        do{
            try content.write(to: url, atomically: true, encoding: .utf8)
        }catch{
            completion(.saveStudentError)
        }
    }
    
    func readDocument(docName: String, completion: (Result<Data, StudentError>) -> Void){
        let url = Self.docDirURL.appendingPathComponent(docName)
        do{
            let data = try Data(contentsOf: url)
            completion(.success(data))
        }catch{
            completion(.failure(.readStudentError))
        }
    }
    func docExist(named docName: String) -> Bool{
        fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path)
    }
}
