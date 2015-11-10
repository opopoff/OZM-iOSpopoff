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
    UIViewController,
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

    var historyMode: Bool = false {
        didSet {
            if historyMode {
                self.reloadData()
            }
        }
    }

    @IBOutlet var collectionView: UICollectionView!

    init() {
        super.init(nibName: "ImagesController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Data

    private func reloadHistory() -> Void {
        let update: ([Image] -> Void) = { imgs in
            self.images = imgs
            self.collectionView?.reloadData()
        }

        APIClient.getLiked().then {
            update($0)
        }
        .catch_ { print("I really should handle this: \($0.localizedDescription)") }
    }

    /**
    Инициирует получение данных с сервера
    */
    private func reloadData() -> Void {
        if self.historyMode {
            self.reloadHistory()
            return
        }

        let update: ([Image] -> Void) = { imgs in
            self.images = imgs
            self.collectionView?.reloadData()
        }

        APIClient.getFeed(category!)
            .then  { update($0) }
            .catch_ { print("I really should handle this: \($0.localizedDescription)") }
    }

    //MARK: - View Struff

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.collectionView)
        self.collectionView.registerNib(
            UINib(nibName: "ImageCell", bundle: nil),
            forCellWithReuseIdentifier: "image"
        )
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

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let image = images?[indexPath.row] {
            print(image.url, terminator: "")
            let imageCtrl = ImageController(image: image)
            navigation.pushViewController(imageCtrl, animated: true)
        }
    }

    func collectionView(
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