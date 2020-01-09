//
//  ContentSizeTable.swift
//  Bitvo-new
//
//  Created by DongMing on 2019-10-11.
//  Copyright © 2019 vogappdevelopers. All rights reserved.
//

import UIKit


final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            isScrollEnabled = contentSize.height > bounds.height
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
