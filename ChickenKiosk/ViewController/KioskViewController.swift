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
    
    private let titleView = TitleView()
    private let categoryView = CategoryView()
    private lazy var menuView = MenuView()
    private lazy var cartView = CartView(mananger: manager)
    private let sumView = SumView()
    private let footerView = FooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        
        titleView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.height.equalTo(50)
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
        
        cartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(menuView.snp.bottom).offset(8)
        }
        
        sumView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.top.equalTo(cartView.snp.bottom).offset(8)
            make.bottom.equalTo(footerView.snp.top).offset(-16)
            make.height.equalTo(70)
        }
        
        footerView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(44)
        }
        
        manager.orderDidSet = { [weak self] in
            guard let self = self else { return }
            self.cartView.reloadData()
            self.sumView.updateTotal(totalPrice: (self.manager.totalPrice))
        }
    }
    
    private func setupMenuView() {
        menuView.collectionView.dataSource = self
        menuView.collectionView.delegate = self
        menuView.pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    private func setupFooterView() {
        footerView.cancelOrderButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        footerView.confirmOrderButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
}

extension KioskViewController {
    @objc func categoryTapped(_ sender: CategoryButton) {
        series = sender.series
        menuView.collectionView.reloadData()
        
        menuView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        menuView.pageControl.numberOfPages = series.chickens.count / 4 + 1
        menuView.pageControl.currentPage = 0
    }
}

extension KioskViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.chickens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChickenCell.identifier, for: indexPath) as? ChickenCell
        else { return UICollectionViewCell() }
        
        cell.bind(series.chickens[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let chicken = series.chickens[index]
        if let index = manager.orders.firstIndex(where: { $0.menu == chicken }) {
            manager.orders[index].count += 1
        } else {
            let newOrder = Order(menu: chicken)
            manager.orders.append(newOrder)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        let height = (collectionView.bounds.height - 10) / 2
        let size = CGSize(width: width, height: height)
        return size
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
