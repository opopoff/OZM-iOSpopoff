//
//  ImagesController.swift
//  OZM
//
//  Created by Semyon Novikov on 11/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class ImagesController:
    UICollectionViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    private var images: [Image]?
    var category: Category? {
        didSet {
            self.title = category?.description
            self.reloadData()
        }
    }

    //MARK: - Data

    /**
    Инициирует получение данных с сервера
    */
    private func reloadData() -> Void {

        let update: ([Image] -> Void) = { imgs in
            self.images = imgs
            self.collectionView?.reloadData()
        }

        APIClient.getFeed(category!)
            .then  { update($0) }
            .catch { println("I really should handle this: \($0.localizedDescription)") }
    }

    //MARK: - View Struff

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    //MARK: - Collection view stuff

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if let image = images?[indexPath.row], size = image.thumbSize() {
            return size
        } else {
            let width = (UIScreen.mainScreen().bounds.width / 2.0) - 25
            let height = width / 1.4
            return CGSize(width: width, height: height)
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let image = images?[indexPath.row] {
            println(image.url)
        }
    }

    override func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView
            .dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! ImageCell

        if let image = images?[indexPath.row] {
            cell.populateWith(image)
        }
        return cell
    }
}