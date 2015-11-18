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

    init() {
        super.init(nibName: "FeedController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func reloadData() -> Void {
        let update: ([Image] -> Void) = { images in
            print("Reload data")
            self.images = images
            self.tableView.reloadData()
        }

        APIClient.getFeed()
            .then { update($0) }
            .catch_ { print("I really should handle this: \($0.localizedDescription)") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "FeedImageCell", bundle: nil), forCellReuseIdentifier: "image")
        self.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view stuff

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < self.images.count {
            if let height = self.images[indexPath.row].height {
                return CGFloat(height)
            }
        }
        return 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Cells count: \(self.images.count)")
        return self.images.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Cell for row")
        let cell = tableView.dequeueReusableCellWithIdentifier("image") as! FeedImageCell
        let image = images[indexPath.row]
        cell.populateWith(image)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
}