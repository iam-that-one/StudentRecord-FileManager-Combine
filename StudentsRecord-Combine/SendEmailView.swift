//
//  SendEmailView.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 18/07/2021.
//

import SwiftUI

struct SendEmailView: View {
    @State var emailes = [String]()
    init() {
       
    }
    @EnvironmentObject var dataStoreVm : DataStoreViewModel
    var emailHelper = EmailHelper()
    @State var subject = ""
    @State var mailBody = ""
    var body: some View {
        ScrollView{
          
            VStack{
                Button(action: {
                //    emailHelper.send(subject: subject, body: mailBody, to: dataStoreVm.emailes)
                }){
                    Image(systemName: "paperplane.fill")
                }
            }.padding()
        }
    }
 
}

struct SendEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SendEmailView()
        
    }
}
