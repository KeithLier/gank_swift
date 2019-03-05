//
//  TopScrollView.swift
//  gank_swift
//
//  Created by keith on 2019/3/4.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

protocol TopScrollViewDelegate: class {
    func topScrollView(_ scrollView: TopScrollView, selectedIndex index: Int)
}

class TopScrollView: UIView {
    weak var delegate: TopScrollViewDelegate?
    
    var titles: [String]? {
        didSet {
            guard let titles = titles else {
                return
            }
            for (index, value) in titles.enumerated() {
                // 添加标题
                let titleButton = UIButton()
                titleButton.setTitle(value, for: .normal)
                titleButton.setTitleColor(UIColor.gray, for: .normal)
                titleButton.setTitleColor(UIColor.black, for: .selected)
                titleButton.backgroundColor = UIColor.clear
                titleButton.tag = 10000 + index
                titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                titleButton.addTarget(self, action: #selector(scrollViewSelectToIndex), for: .touchUpInside)
                scrollView.addSubview(titleButton)
                if (index == 0) {
                    titleButton.isSelected = true
                }
                buttonArray.append(titleButton)
                
                // 添加滑块
                let sliderWidth: CGFloat = getTextWidth(text: buttonArray.first!.titleLabel!.text!, height: 40, fontSize: buttonArray.first!.titleLabel!.font.pointSize)
                let sliderX: CGFloat = 15
                sliderView.frame = CGRect(x: sliderX, y: 40 - 2, width: sliderWidth, height: 2)
                scrollView.addSubview(sliderView)
                scrollView.sendSubviewToBack(sliderView)
            }
        }
    }
    
    private lazy var buttonArray = [UIButton]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var sliderView: UIView = {
        let sliderView = UIView()
        sliderView.backgroundColor = UIColor.black
        return sliderView
    }()
    
    private var cuurentIndex: Int = 0
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.bounds.height
        scrollView.frame = self.bounds
        
        guard buttonArray.count > 0 else {
            return
        }
        var width: CGFloat = 0
        let padding: CGFloat = 15
        for (index, _) in buttonArray.enumerated() {
            let titleButton = buttonArray[index]
            let textWidth: CGFloat = getTextWidth(text: titleButton.titleLabel!.text!, height: height, fontSize: titleButton.titleLabel!.font.pointSize) + 2 * padding
            titleButton.frame = CGRect(x: width, y: 0, width: textWidth, height: height)
            width += titleButton.frame.width
        }
        scrollView.contentSize = CGSize(width: width, height: height)
        
        selectedButton(index: cuurentIndex)
        
        moveSlider(moveX: buttonArray[cuurentIndex].frame.minX, changeWidth: buttonArray[cuurentIndex].frame.width)
    }
}

extension TopScrollView {
    private func setupUI() {
        self.addSubview(self.scrollView)
    }
    
    private func selectedButton(index: Int) {
        let width = self.frame.width
        var selectedButton = buttonArray[cuurentIndex]
        selectedButton.isSelected = false
        selectedButton = buttonArray[index]
        cuurentIndex = index
        selectedButton.isSelected = true
        
        let contentWidth = buttonArray.last!.frame.maxX
        if (contentWidth < width) {
            return
        }
        
        let rect = selectedButton.superview!.convert(selectedButton.frame, to: self)
        let buttonWidth = selectedButton.frame.width
        let contentOffset = scrollView.contentOffset
        if contentOffset.x <= (width / 2 - rect.origin.x - buttonWidth / 2) {
            // 最左边的情况
            scrollView.setContentOffset(CGPoint(x: 0, y: contentOffset.y), animated: true)
        } else if contentOffset.x - (width / 2 - rect.origin.x - buttonWidth / 2) + width >= contentWidth {
            // 最右边的情况
            scrollView.setContentOffset(CGPoint(x: contentWidth - width, y: contentOffset.y), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x:contentOffset.x - (width / 2 - rect.origin.x - buttonWidth / 2),y:contentOffset.y), animated: true)
        }
    }
    
    private func getTextWidth(text: String, height: CGFloat, fontSize: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.width
        
    }
    
    @objc private func scrollViewSelectToIndex(sender: UIButton) {
        let index = sender.tag - 10000
        self.selectedButton(index: index)
        
        let button = buttonArray[index]
        UIView.animate(withDuration: 0.25) {
            self.moveSlider(moveX: button.frame.minX, changeWidth: button.frame.width)
        }
        delegate?.topScrollView(self, selectedIndex: index)
    }
    
    private func moveSlider(moveX: CGFloat, changeWidth: CGFloat) {
        let padding: CGFloat = 15
        sliderView.frame.origin.x =  moveX + padding
        sliderView.frame.size.width = changeWidth - 2 * padding
    }
}
