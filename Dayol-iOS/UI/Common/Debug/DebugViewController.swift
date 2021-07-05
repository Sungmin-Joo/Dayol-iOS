//
//  DebugViewController.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/20.
//

import UIKit

#if BETA
class DebugViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
#endif

