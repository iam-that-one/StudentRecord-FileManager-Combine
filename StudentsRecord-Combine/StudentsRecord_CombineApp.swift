//
//  StudentsRecord_CombineApp.swift
//  StudentsRecord-Combine
//
//  Created by Abdullah Alnutayfi on 19/07/2021.
//

import SwiftUI

@main
struct StudentsRecord_CombineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DataStoreViewModel())
        }
    }
}
