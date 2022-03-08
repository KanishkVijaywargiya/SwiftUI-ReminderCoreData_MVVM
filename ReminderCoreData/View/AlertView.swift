//
//  AlertView.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 02/12/21.
//

import SwiftUI

struct AlertView: View {
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
    @State private var editedText: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Add Category")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.top, 15)
            
            HStack {
                TextField(
                    "Enter text",
                    text: $editedText,
                    onEditingChanged: { _ in },
                    onCommit: {
                        textEntered = editedText
                        editedText = ""
                        self.showingAlert.toggle()
                    })
                    .padding(5)
                    .background(Color(.lightGray).opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(10)
            
            Divider()
            
            HStack {
                // cancel button
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        editedText = ""
                        textEntered = ""
                        showingAlert.toggle()
                    }
                }
                ) {
                    Text("Cancel")
                }
                Spacer()
                
                Divider()
                
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        textEntered = editedText
                        editedText = ""
                        showingAlert.toggle()
                    }
                }
                ) {
                    Text("Done")
                }
                Spacer()
            }
        }
        .frame(width: 300, height: 150)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(textEntered: .constant(""), showingAlert: .constant(true))
    }
}
