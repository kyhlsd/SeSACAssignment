//
//  SelectTamagotchiViewController.swift
//  Tamagotchi
//
//  Created by 김영훈 on 8/23/25.
//

import UIKit
import SnapKit
import Toast
import RxSwift
import RxCocoa

protocol VCTransitionDelegate: AnyObject {
    func selectHandler(isInit: Bool)
}

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
        let input = SelectTamagotchiViewModel.Input(cellTap: collectionView.rx.modelSelected(TamagotchiType.self))
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: collectionView.rx.items) { collectionView, item, element in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectTamagotchiCollectionViewCell.identifier, for: IndexPath(item: item, section: 0)) as! SelectTamagotchiCollectionViewCell
                cell.setData(type: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.showAlertTrigger
            .bind(with: self) { owner, type in
                owner.showSelectAlert(type: type)
            }
            .disposed(by: disposeBag)
        
        navigationItem.title = output.navigationTitle
    }

    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func showSelectAlert(type: TamagotchiType) {
        let alert = SelectTamagotchiAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setData(type: type)
        alert.delegate = self
        present(alert, animated: true)
    }
}

extension SelectTamagotchiViewController: VCTransitionDelegate {
    func selectHandler(isInit: Bool) {
        if isInit {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
                self?.navigationController?.viewControllers = [CareTamagotchiViewController()]
            }
        } else {
            view.makeToast("다마고치가 변경되었습니다", duration: 1, position: .bottom)
        }
    }
}
