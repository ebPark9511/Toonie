//
//  ForYouCollectionViewCell.swift
//  Toonie
//
//  Created by 이재은 on 07/03/2019.
//  Copyright © 2019 Yapp. All rights reserved.
//

import UIKit

// '당신을 위한 공감툰' 두번째 컬렉션뷰셀
final class ForYouCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var forYouToonImageView: UIImageView!
    @IBOutlet weak var forYouToonTitleLabel: UILabel!
    @IBOutlet private weak var forYouToonTagLabel: UILabel!
    @IBOutlet private weak var bookMarkButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        forYouToonImageView.image = nil
        forYouToonTitleLabel.text = nil
        forYouToonTagLabel.text = nil
        bookMarkButton.isSelected  = false
    }
    
    // MARK: - Functions
    
    /// 컬렉션뷰셀 데이터 설정
    func setForYouCollectionViewCellProperties(_ toonList: ToonList) {
        prepareForReuse()
        
        DispatchQueue.main.async {
            self.forYouToonImageView.imageFromUrl(toonList.instaThumnailUrl,
                                                  defaultImgPath: "collectionAddLoading")
            self.forYouToonImageView.setCorner(cornerRadius: 3)
            self.forYouToonTitleLabel.text = toonList.toonName
        }
        var tagList = ""
        if let toonTagList = toonList.toonTagList {
            for index in 0..<toonTagList.count {
                tagList += "#" + toonTagList[index] + " "
            }
            DispatchQueue.main.async {
                self.forYouToonTagLabel.text = tagList
            }
        }
    }
}
