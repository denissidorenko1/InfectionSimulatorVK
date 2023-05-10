//
//  SimulationScreen.swift
//  InfectionSimulatorVK
//
//  Created by Denis on 10.05.2023.
//

import UIKit

final class SimulationScreen: UIViewController {
    private var collection: UICollectionView!
    weak var model: InfectionSimulator?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    // закостылил расчет количества ячеек по горизонтали
    private func getWidth(_ layout: UICollectionViewFlowLayout) -> Int {
        let viewWidth = view.bounds.width - layout.sectionInset.left*2
        let size = layout.itemSize.width
        var storage: [Int] = []
        for i in 0...10 {
            storage.append(Int(viewWidth) - Int(size)*i - Int(size))
        }
        return storage.indices.filter {storage[$0] > 0}.last!
    }
    
    private func setupLayout() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 50, height: 50)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = setupLayout()
        model?.width = getWidth(layout)
        
        collection = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collection?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collection?.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // начинаем обсчет больных
        model?.calculateIll() { [weak self] in
            DispatchQueue.main.async {
                self?.collection.reloadData()
            }
        }
    }
}

extension SimulationScreen: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // обозначаем больного в модели и обновляем UI
        model?.people[indexPath.item] = .ill
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .red
    }
    
}

extension SimulationScreen: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else {
            return 0
        }
        return model.quantity
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        if model?.people[indexPath.item] != .healthy {
                myCell.backgroundColor = .red
        } else {
            myCell.backgroundColor = .green
        }
        return myCell
    }
}
