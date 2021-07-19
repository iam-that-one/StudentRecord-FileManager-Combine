//
//  SecondEmailView.swift
//  StudentRecordNoCombine
//
//  Created by Abdullah Alnutayfi on 18/07/2021.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

struct SecondMailView: UIViewControllerRepresentable {
    var recipent : String
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SecondMailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([recipent])
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<SecondMailView>) {

    }
}
