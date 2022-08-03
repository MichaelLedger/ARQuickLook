//
//  ContentView.swift
//  ARQuickLook
//
//  Created by Gavin Xiang on 2022/8/2.
//

import SwiftUI
import QuickLook
import ARKit

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!").padding()
        ARQLViewController()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ARQLViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return UINavigationController.init(rootViewController: ViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class ViewController: UIViewController, QLPreviewControllerDataSource {
    
    var currentPreviewItemIndex: Int = 0
    
    /*
     Resources could be download from:
     https://developer.apple.com/augmented-reality/quick-look/
     */
    var resources: [String] = ["hab_en.reality", "CosmonautSuit_en.reality", "LunarRover_English.reality", "toy_biplane.usdz"]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        let itemsCount = numberOfPreviewItems(in: previewController)
        previewController.currentPreviewItemIndex = currentPreviewItemIndex
        present(previewController, animated: true) {
            if self.currentPreviewItemIndex < itemsCount - 1 {
                self.currentPreviewItemIndex += 1
            } else {
                self.currentPreviewItemIndex = 0
            }
        }
    }

    /*
     https://developer.apple.com/documentation/quicklook/qlpreviewcontrollerdatasource/1617017-numberofpreviewitems
     
     Discussion
     The system invokes this method to inform the preview controller of the number of preview items available.
     If you push a Quick Look preview controller into view using a UINavigationController object that has a toolbar, the system automatically displays arrows in the toolbar to navigate among the items in the navigation list. If you’re not displaying a toolbar and want to provide your own method of switching among items, use the currentPreviewItemIndex property to indicate the item you want to display.
     If you display a preview controller modally (full screen), the controller includes navigation arrows if there’s more than one item in the navigation list.
     */
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return resources.count }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let resource = resources[index]
        let resourceName = resource.components(separatedBy: ".").first
        let resourceType = resource.components(separatedBy: ".").last
        guard let path = Bundle.main.path(forResource: resourceName, ofType: resourceType) else { fatalError("Couldn't find the supported input file.") }
        let url = URL(fileURLWithPath: path)
        
        //To prevent the user from scaling your virtual content or to customize the default share sheet behavior, use ARQuickLookPreviewItem instead of QLPreviewItem.
        return url as QLPreviewItem
    }
    
}
