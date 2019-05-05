//
//  LookDetailViewController.swift
//  Toonie
//
//  Created by ebpark on 06/03/2019.
//  Copyright © 2019 Yapp. All rights reserved.
//

import UIKit

///둘러보기 상세 - LookViewController의 CollectionView의 didSelected시 이동되는 화면
final class LookDetailViewController: GestureViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var lookDetailTitleLabel: UILabel!
    @IBOutlet private weak var lookDetailCollectionView: UICollectionView!
    @IBOutlet private weak var lookDetailCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    var selectedKeyword: String = ""
    
    private var toonDataList = [ToonInfoList]()
    private var toonList = [ToonOfTag]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookDetailTitleLabel.text = selectedKeyword
        setCollectionViewLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topSetting" {
            if let viewController = segue.destination as? LookDetailTopSelectViewController {
                viewController.selectedKeyword = self.selectedKeyword
                viewController.tagDidTapClosure = {
                    (tagString) -> Void in
                    LookToonOfTagService.shared
                        .getLookToonOfTag(toonTag: tagString,
                                          completion: { res in
                        self.toonList = [res]
                        guard let toonData = res.toonInfoList else { return }
                        self.toonDataList = toonData
                        self.lookDetailCollectionView.reloadData()
                    })
                
                }
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Function
    
    ///컬렉션 뷰 아이템 크기, 위치조정
    private func setCollectionViewLayout() {
        lookDetailCollectionViewFlowLayout.scrollDirection = .vertical
        lookDetailCollectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.322 ,
                                                               height: UIScreen.main.bounds.width * 0.322)
        lookDetailCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0,
                                                                       left: 5 * CommonUtility.getDeviceRatioWidth(),
                                                                       bottom: 0,
                                                                       right: 5 * CommonUtility.getDeviceRatioWidth())
        lookDetailCollectionViewFlowLayout.minimumLineSpacing = 1.0 * CommonUtility.getDeviceRatioWidth()
    } 
    
    /// 인스타툰 상세정보 화면으로 이동
    private func moveDetailToon() {
        let storyboard = UIStoryboard(name: "Detail",
                                      bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailToonView")
        CommonUtility.sharedInstance.mainNavigationViewController?.pushViewController(viewController,
                                                                                      animated: true)
    }
    
    ///타이틀 세팅
    func setLookDetailTitleLabel(titleString: String) {
        self.lookDetailTitleLabel.text = titleString
    }
}

// MARK: - UICollectionViewDataSource

extension LookDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return toonDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "LookDetailCell",
                                 for: indexPath) as? LookDetailCell
            else { return UICollectionViewCell() }

        if let thumnailURL = toonDataList[indexPath.item].instaThumnailUrl {
            cell.setImageView(imageURL: thumnailURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        //화면이동
        self.moveDetailToon()
    }
}

// MARK: - UICollectionViewDelegate

extension LookDetailViewController: UICollectionViewDelegate {
    
}
