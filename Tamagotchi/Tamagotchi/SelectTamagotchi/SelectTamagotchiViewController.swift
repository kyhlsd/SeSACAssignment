//
//  SelectTamagotchiViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/23/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectTamagotchiViewController: UIViewController {

    private var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let sceneWidth = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.width ?? 0
        let itemWidth: CGFloat = (sceneWidth - (20 * 2) - (20 * 2)) / 3
        let itemHeight = itemWidth + 28
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SelectTamagotchiCollectionViewCell.self, forCellWithReuseIdentifier: SelectTamagotchiCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let viewModel = SelectTamagotchiViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
        bind()
    }
    
    private func bind() {
        let input = SelectTamagotchiViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: collectionView.rx.items) { collectionView, item, element in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectTamagotchiCollectionViewCell.identifier, for: IndexPath(item: item, section: 0)) as! SelectTamagotchiCollectionViewCell
                cell.setData(type: element)
                return cell
            }
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = .background
        navigationItem.title = "다마고치 선택하기"
        
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
