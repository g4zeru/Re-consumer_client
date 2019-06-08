//
//  PreviewController.swift
//  Re-Consumer
//
//  Created by iniad on 2019/06/08.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit

class PreviewController: UIViewController {
    var encodedImage: String!
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        print("encded: " + encodedImage)
    }
}
