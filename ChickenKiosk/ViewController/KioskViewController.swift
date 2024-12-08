//
//  ViewController.swift
//  ChickenKiosk
//
//  Created by 권승용 on 11/25/24.
//

import UIKit
import SnapKit

class KioskViewController: UIViewController {
    
    var series: ChickenSeries = .honey
    let manager = OrderManager(orderDidSet: {})
    
    private lazy var titleView = TitleView()
    private lazy var categoryView = CategoryView()
    private lazy var menuView = MenuView()
    private lazy var cartView = CartView(mananger: manager)
    private lazy var sumView = SumView()
    private lazy var footerView = FooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        categoryView.delegate = self
        menuView.delegate = self
        configureUI()
        setupMenuView()
        setupFooterView()
    }
    
    private func configureUI() {
        let subviews = [
            titleView,
            categoryView,
            menuView,
            cartView,
            sumView,
            footerView,
        ]
        
        subviews.forEach {
            view.addSubview($0)
        }
        
        titleView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.height.equalTo(50)
        }
        
        categoryView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
        
        menuView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        cartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(menuView.snp.bottom).offset(8)
        }
        
        sumView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.top.equalTo(cartView.snp.bottom).offset(8)
            $0.bottom.equalTo(footerView.snp.top).offset(-16)
            $0.height.equalTo(70)
        }
        
        footerView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(44)
        }
        
        manager.orderDidSet = { [weak self] in
            guard let self = self else { return }
            self.cartView.reloadData()
            self.sumView.updateTotal(totalPrice: (self.manager.totalPrice))
        }
    }
    
    private func setupMenuView() {
        menuView.pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    private func setupFooterView() {
        footerView.cancelOrderButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        footerView.confirmOrderButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
}

extension KioskViewController: CategorySelectDelegate {
    func updateCategory(_ series: ChickenSeries) {
        self.series = series
        menuView.collectionView.reloadData()
        
        menuView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        menuView.pageControl.numberOfPages = series.chickens.count / 4 + 1
        menuView.pageControl.currentPage = 0
    }
    
    func getSeriesInfo() -> ChickenSeries {
        return series
    }
    
    func didTapChickenCell(of index: Int) {
        let chicken = series.chickens[index]
        if let index = manager.orders.firstIndex(where: { $0.menu == chicken }) {
            manager.orders[index].count += 1
        } else {
            let newOrder = Order(menu: chicken)
            manager.orders.append(newOrder)
        }
    }
}

extension KioskViewController: UIScrollViewDelegate {
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let pageWidth = menuView.collectionView.bounds.width / 2
        let offsetX = CGFloat(sender.currentPage) * pageWidth
        menuView.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = ceil(Double(scrollView.contentOffset.x / pageWidth))
        menuView.pageControl.currentPage = Int(currentPage)
    }
}

extension KioskViewController {
    @objc func cancelButtonTapped() {
        presentAlert(true)
    }
    
    @objc func confirmButtonTapped() {
        if manager.orders.isEmpty {
            failAlert()
        } else {
            presentAlert(false)
        }
    }
    
    private func presentAlert(_ isCancelling: Bool) {
        let alert = UIAlertController(
            title: isCancelling ? "주문취소" : "주문하기",
            message: isCancelling ? "장바구니 내역이 삭제됩니다. 취소하시겠습니까?" : "주문을 완료하시겠습니까?",
            preferredStyle: .alert
        )
        let yesButton = UIAlertAction(title: "네", style: .default, handler: { [weak self] _ in
            self?.manager.orders.removeAll()
            if !isCancelling {
                self?.completeAlert()
            }
        })
        let noButton = UIAlertAction(title: "아니오", style: .destructive)
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
    
    private func completeAlert() {
        let alert = UIAlertController(title: "주문완료", message: "주문이 완료되었습니다!", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okayButton)
        present(alert, animated: true)
    }
    
    private func failAlert() {
        let alert = UIAlertController(title: "주문실패", message: "장바구니가 비어있습니다.\n먹고 싶은 치킨을 담아주세요!", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okayButton)
        present(alert, animated: true)
    }
}


#if DEBUG
import SwiftUI
struct PreView: PreviewProvider {
    static var previews: some View {
        KioskViewController().toPreview()
    }
}
#endif
