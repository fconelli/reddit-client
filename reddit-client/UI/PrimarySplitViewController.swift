//
//  PrimarySplitViewController.swift
//  reddit-client
//
//  Created by Francisco Conelli on 15/01/2021.
//

import Foundation
import UIKit

class PrimarySplitViewController: UISplitViewController,
                                  UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = DisplayMode.automatic
    }

    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
