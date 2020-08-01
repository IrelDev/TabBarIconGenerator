//
//  ContentView.swift
//  TabBarIconGenerator
//
//  Created by Kirill Pustovalov on 27.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var imageModel: ImageModel?
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            DragAndDropView(imageModel: self.$imageModel)
                .frame(width: 320)
            Spacer()
            VStack {
                Image("SFSquareArrowDown")
                Text("Export")
                    .font(.title)
            }
            .frame(width: 320, height: 320)
            .background(Color("CardColor").opacity(0.2))
            .cornerRadius(20)
            .onTapGesture {
                guard self.imageModel != nil else { return }
                Presenter.shared.presentNSOpenPanelForFolder { (result) in
                    if case let .success(url) = result {
                        Presenter.shared.createImageSetFrom(image: self.imageModel!.image, with: self.imageModel!.imageName, at: url)
                    }
                }
            }
            Spacer()
        }
        .frame(width: 700, height: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
