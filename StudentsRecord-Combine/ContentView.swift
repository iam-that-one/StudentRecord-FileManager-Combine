//
//  ContentView.swift
//  StudentsRecord-Combine
//
//  Created by Abdullah Alnutayfi on 19/07/2021.
//

import SwiftUI

struct ContentView: View {
    @State var search = ""
    var emailHelper = EmailHelper()
    @State var showSendEmailView = false
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(Color(.systemGray6))
    }
    @EnvironmentObject var dataStoreVM : DataStoreViewModel
    
    @State var modelType : ModelType? = nil
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color(.systemGray6)
            NavigationView{
                VStack{
                    List{
                        
                        TextField("Search",text: $search)
                            .frame(width: 300, height: 40)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ForEach(search == "" ? dataStoreVM.students.value: dataStoreVM.students.value.filter{$0.name.lowercased().contains(search.lowercased())}){ student in
                            Button(action:{
                                modelType = .update(student)
                            }){
                                Text(student.name)
                            }
                        }.onDelete(perform: dataStoreVM.deleteStudent.send)
                    }.listStyle(InsetGroupedListStyle())
                    .toolbar{
                        ToolbarItem(placement: .principal){
                            Text("Students Record")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        }
                        
                    }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(action:{
                                emailHelper.send(subject: "UU", body: "Dear Students,\n", to: dataStoreVM.emailes)
                                //  sendEmail(email: "")
                                print("######")
                            }){
                                Image(systemName: "envelope.fill")
                            }
                        }
                        
                    }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            addButton
                        }
                        
                    }
                }
            }.edgesIgnoringSafeArea(.all)
            
        }
        .fullScreenCover(item: $modelType){ modelType in
            modelType
        }
        .alert(item: $dataStoreVM.studentError) { studentError in
            Alert(title: Text("Sorry!"), message: Text(studentError.error.localizedDescription))
        }
    }
    var addButton : some View{
        Button(action: {
            modelType = .new
        }){
            Image(systemName: "plus.circle.fill")
        }
    }
    func sendEmail(email: String){
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cannot open URL")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStoreViewModel())
    }
}
