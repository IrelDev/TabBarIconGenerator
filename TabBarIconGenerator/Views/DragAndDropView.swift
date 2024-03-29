//
//  DragAndDropView.swift
//  TabBarIconGenerator
//
//  Created by Kirill Pustovalov on 28.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import SwiftUI

struct DragAndDropView: View {
    @Binding var imageModel: ImageModel?

    var body: some View {
        return Group {
            if self.imageModel != nil {
                Image(nsImage: self.imageModel!.image)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 320)
            } else {
                VStack {
                    if #available(macOS 11.0, *) {
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                    } else {
                        Image("SFSquareArrowDown")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                    }
                    Text("Drag & Drop or Tap")
                        .font(.title)
                }
                .frame(width: 320)
            }
        }
        .background(Image("ImagePlaceholderBackground").resizable().scaledToFill().opacity(0.1).foregroundColor(Color(.labelColor)).background(Color("CardColor").opacity(0.5)))
        .frame(height: 320)
        .cornerRadius(20)

        .onTapGesture {
            Presenter.shared.presentNSOpenPanelForImage { response in
                if case let .success(nsOpenPanelResponse) = response {
                    self.imageModel = nsOpenPanelResponse
                }
            }
        }

        .onDrop(of: ["public.url", "public.file-url"], isTargeted: nil) { items -> Bool in
            guard let item = items.first,
                  let identifier = item.registeredTypeIdentifiers.first else { return false }

            if identifier == "public.url" || identifier == "public.file-url" {
                item.loadItem(forTypeIdentifier: identifier, options: nil) { urlData, _ in
                    DispatchQueue.main.async {
                        guard let urlData = urlData as? Data else { return }

                        let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        guard let image = NSImage(contentsOf: url) else { return }
                        let imageName = url.deletingPathExtension().lastPathComponent
                        self.imageModel = ImageModel(imageName: imageName, image: image)
                    }
                }
                return true
            } else { return false }
        }
    }
}

struct DragAndDropView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropView(imageModel: .constant(nil))
    }
}
