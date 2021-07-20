//
//  StudentFormView.swift
//  StudentsRecord-Combine
//
//  Created by Abdullah Alnutayfi on 17/07/2021.
//

import SwiftUI
import MessageUI
struct StudentFormView: View {
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    @State private var isShowingMessages = false
    @EnvironmentObject var dataStoreVM : DataStoreViewModel
    @ObservedObject var SFVm :  StudentFormViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(.systemGray6)
                VStack{
                    ScrollView{
                        VStack(alignment: .leading){
                            Text("STUDENT NAME")
                                .foregroundColor(.gray)
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    TextField("student name", text: $SFVm.name)
                                        .padding()
                                )
                            
                            Text("STUDENT SCHOOL")
                                .foregroundColor(.gray)
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    TextField("school", text: $SFVm.school)
                                        .padding()
                                )
                            Text("STUDENT ADDRESS")
                                .foregroundColor(.gray)
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    TextField("student address", text: $SFVm.address)
                                        .padding()
                                )
                            Text("STUDENT EMAIL")
                                .foregroundColor(.gray)
                            HStack{
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        HStack{
                                            TextField("student email", text: $SFVm.email)
                                                .padding()
                                            Button(action:{
                                                sendEmail(email: SFVm.email)
                                                print(SFVm.phone)
                                                // if you use SecondEmailView struct, but does not work
                                                // isShowingMailView.toggle()
                                            }){
                                                Image(systemName: "envelope.fill")
                                                    .frame(width: 30, height: 30)
                                                    .background(Color.gray.opacity(0.30))
                                                    .cornerRadius(10)
                                                    .padding()
                                            }
                                            // if you use SecondEmailView struct, but does not work
                                            //.disabled(!MFMailComposeViewController.canSendMail())
                                            //.sheet(isPresented: $isShowingMailView) {
                                            //    SecondMailView(recipent: SFVm.email,result: self.$result)
                                            //}
                                            
                                            
                                        }
                                    )
                                
                            }
                            Text("STUDENT PHONE")
                                .foregroundColor(.gray)
                            HStack{
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 50, alignment: .center)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        HStack{
                                            TextField("+966", text: $SFVm.phone)
                                                .padding()
                                            Divider()
                                            Button(action:{
                                                call(phoneNumber: SFVm.phone)
                                                print(SFVm.phone)
                                            }){
                                                Image(systemName: "phone.fill")
                                                    .frame(width: 30, height: 30)
                                                    .background(Color.gray.opacity(0.30))
                                                    .cornerRadius(10)
                                                    .padding()
                                            }
                                            Divider()
                                            Button(action:{
                                                // if you use MessageComposeView class, but dose not work
                                                //   self.isShowingMessages = true
                                                sendMessage()
                                            }){
                                                Image(systemName: "envelope.fill")
                                                    .frame(width: 30, height: 30)
                                                    .background(Color.gray.opacity(0.30))
                                                    .cornerRadius(10)
                                                    .padding()
                                            }
                                            
                                            // if you use MessageComposeView class, but dose not work
                                            // .sheet(isPresented: $isShowingMessages){
                                            //     MessageComposeView(recipients: [SFVm.phone], body: "") { messageSent in
                                            //                    print("MessageComposeView with message sent? \(messageSent)")
                                            //                }
                                            // }
                                        }
                                    )
                                
                            }
                        }.padding()
                        
                    }  .frame(height: 500)
                    
                    .background(Color(.systemGray6))
                    .offset(y:-10)
                    .toolbar{
                        ToolbarItem(placement: .principal){
                            Text("Student")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            cancelButton
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            saveUpdareButtons
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }.ignoresSafeArea()
        
    }
    var cancelButton : some View{
        Button("Cancel"){
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func save(){
        let student = Student(name: SFVm.name, school: SFVm.school,address: SFVm.address,email: SFVm.email,phone: SFVm.phone)
        dataStoreVM.addStudent.send(student)
        presentationMode.wrappedValue.dismiss()
    }
    func update(){
        let student = Student(id: SFVm.id!, name: SFVm.name, school: SFVm.school,address: SFVm.address,email: SFVm.email,phone: SFVm.phone)
        dataStoreVM.updateStudent.send(student)
        presentationMode.wrappedValue.dismiss()
    }
    
    var saveUpdareButtons : some View{
        Button(SFVm.isUpdating ? "update" : "Save", action: SFVm.isUpdating ? update : save)
            .disabled(SFVm.isDisabled)
        
    }
    func call(phoneNumber: String){
        let phone = "tel://"
        let phoneNumberformatted = phone + phoneNumber
        guard let url = URL(string: phoneNumberformatted) else { return }
        
        UIApplication.shared.open(url)
        // print(url)
    }
    func sendMessage(){
        let sms = "sms:\(SFVm.phone)&body=Hello dear \(SFVm.name), "
        let url = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
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

struct StudentFormView_Previews: PreviewProvider {
    static var previews: some View {
        StudentFormView(SFVm: StudentFormViewModel())
            .environmentObject(DataStoreViewModel())
    }
}


