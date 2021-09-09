//
//  InitialPage.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 9/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct InitialPageMenu: View {

    var systemImageName: String
    var title: String
    var subtitle: String

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            Image(systemName: systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 26, height: 26, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(title).fontWeight(.bold)
                Text(subtitle)
                    .font(.subheadline)
            }

        }
    }
}


struct InitialPage: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: TasksPage(),
                    label: {
                        InitialPageMenu(systemImageName: "checkmark.circle", title: "Tasks", subtitle: "A generic example of a to do list app")
                    })
                NavigationLink(
                    destination: GalleryPage(),
                    label: {
                        InitialPageMenu(systemImageName: "photo", title: "Gallery", subtitle: "Attachments Example (Binary Data)")
                    })
            }
            .navigationTitle("Combine Ditto")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct InitialPage_Previews: PreviewProvider {
    static var previews: some View {
        InitialPage()
    }
}
