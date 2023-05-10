//
//  ViewController.swift
//  InfectionSimulatorVK
//
//  Created by Denis on 10.05.2023.
//

import UIKit

final class SettingsController: UIViewController {
    let simVC = SimulationScreen()
    let simulator = InfectionSimulator(quantity: 100, refreshRate: 1, infectionFactor: 1, width: 6)
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Количество людей: 100"
        return label
    }()
    
    let infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Фактор заражения: 2"
        return label
    }()
    
    let refreshLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Время обновления: 1 сек."
        return label
    }()
    
    lazy var verticalStack = UIStackView(frame: CGRect(x: 10, y: 120, width: view.bounds.width - 20, height: 190))
    
    let quantityStack = UIStackView()
    let infectionFactorStack = UIStackView()
    let refreshTimeStack = UIStackView()
    
    lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Рассчитать", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    lazy var quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 20
        stepper.maximumValue = 1000
        stepper.stepValue = 20
        stepper.value = 100
        stepper.addTarget(self, action: #selector(quantityChanged), for: .valueChanged)
        return stepper
    }()
    
    lazy var infectionFactorStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 3
        stepper.stepValue = 1
        stepper.value = 2
        stepper.addTarget(self, action: #selector(infectionFactorChanged), for: .valueChanged)
        return stepper
    }()
    
    lazy var refreshRateStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 4
        stepper.stepValue = 1
        stepper.value = 2
        stepper.addTarget(self, action: #selector(refreshRateChanged), for: .valueChanged)
        return stepper
    }()
    
    @objc func refreshRateChanged() {
        refreshLabel.text = "Время обновления: \(Int(refreshRateStepper.value)) сек."
        simulator.refreshRate = Int(refreshRateStepper.value)
    }
    
    @objc func quantityChanged() {
        quantityLabel.text = "Количество людей: \(Int(quantityStepper.value))"
        simulator.setQuantity(quantity: Int(quantityStepper.value))
    }
    
    @objc func infectionFactorChanged() {
        infectionFactorLabel.text = "Фактор заражения: \(Int(infectionFactorStepper.value))"
        simulator.infectionFactor = Int(infectionFactorStepper.value)
    }
    
    private func setupStacks() {
        quantityStack.axis = .horizontal
        quantityStack.addArrangedSubview(quantityLabel)
        quantityStack.addArrangedSubview(quantityStepper)
        
        infectionFactorStack.axis = .horizontal
        infectionFactorStack.addArrangedSubview(infectionFactorLabel)
        infectionFactorStack.addArrangedSubview(infectionFactorStepper)
        
        refreshTimeStack.axis = .horizontal
        refreshTimeStack.addArrangedSubview(refreshLabel)
        refreshTimeStack.addArrangedSubview(refreshRateStepper)
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.addArrangedSubview(quantityStack)
        verticalStack.addArrangedSubview(infectionFactorStack)
        verticalStack.addArrangedSubview(refreshTimeStack)
        verticalStack.addArrangedSubview(calculateButton)
        view.addSubview(verticalStack)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        simVC.model = simulator
        setupStacks()
        calculateButton.addTarget(self, action: #selector(openComputationScreen), for: .touchUpInside)
    }

    @objc private func openComputationScreen() {
        self.navigationController?.pushViewController(simVC, animated: true)
    }
}

