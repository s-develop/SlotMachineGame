//
//  InfoView.swift
//  Slot Machine
//
//  Created by Sergei on 23.04.2021.
//

import SwiftUI

struct InfoView: View {
  
    @Environment(\.presentationMode) var presentationMode
  
    var body: some View {
        VStack(alignment: .center, spacing: 10){
           LogoView()
          
           Spacer()
            Form{
                Section(header: Text("About the application")){
            FormRowView(firstItem: "Application", secondItem: "Slot Mashine")
            FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
            FormRowView(firstItem: "Developer", secondItem: "Matveev Sergei")
            FormRowView(firstItem: "Designer", secondItem: "Robert Petras")
            FormRowView(firstItem: "Website", secondItem: "swiftuimasterclass.com")
            FormRowView(firstItem: "Copyright", secondItem: "2021 All tights reserved")
            FormRowView(firstItem: "Version", secondItem: "1.0.0")
                
                }
            }
        }
        .padding(.top, 40)
        .overlay(
            Button(action: {
                //Action
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
            .padding(.top, 30)
            .padding(.trailing, 20)
            .accentColor(Color.secondary)
            , alignment: .topTrailing
        )
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

struct FormRowView: View {
    
    var firstItem: String
    
    var secondItem: String
    
    var body: some View {
        
                HStack{
                    Text(firstItem).foregroundColor(Color.gray)
                    Spacer()
                    Text(secondItem)
                }
         
    }
}
