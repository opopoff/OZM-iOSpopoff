//
//  FeedController.swift
//  OZM
//
//  Created by Semyon Novikov on 09/11/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class FeedController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var images: [Image] = []
    @IBOutlet weak var tableView: UITableView!

    private func reloadData() -> Void {
        let update: ([Image] -> Void) = { images in
            self.images = images
            self.tableView!.reloadData()
        }

        APIClient.getFeed()
            .then { update($0) }
            .catch_ { print("I really should handle this: \($0.localizedDescription)") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.registerNib(UINib(nibName: "FeedImageCell", bundle: nil), forCellReuseIdentifier: "image")
        self.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view stuff

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("image") as! FeedImageCell
        let image = images[indexPath.row]
        cell.populateWith(image)
        return cell
    }
}