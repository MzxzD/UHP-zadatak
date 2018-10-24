//
//  HomeViewController.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class HomeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let disposeBag = DisposeBag()
    var alert = UIAlertController()
    var homeViewModel: HomeViewModelProtocol!
    let picker = UIPickerView()
    var activeTextField: UITextField!
    
    var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Input Value"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var fromValueTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "FROM value"
        return textField
    }()
    
    var toValueTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "To value"
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Result"
        return label
    }()
    let calculateButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 150, height: 50))
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
      
        return button
        
        
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeViewModel.startDownload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDataObservable()
        homeViewModel.getDataFromApi().disposed(by: disposeBag)
    
    }
    
    
    
    //    func initializeError() {
    //        let errorObserver = homeViewModel.errorOccured
    //        errorObserver
    //            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    //            .observeOn(MainScheduler.instance)
    //            .subscribe(onNext: { (event) in
    //                if event {
    //                    print("error")
    //                    // ERROR OCCURED
    //                }
    //            })
    //            .disposed(by: disposeBag)
    //    }
    
    
    func initializeDataObservable(){
        print("DataIsReadyObserver")
        let observer = homeViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if event {
                    self.setupView()
                }
            })
            .disposed(by: disposeBag)
    }
    

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeTextField = textField
        
        switch textField {
        case fromValueTextField:
            fromValueTextField.text = .empty
            self.toValueTextField.text = "HRK"
        case toValueTextField:
            toValueTextField.text = .empty
            self.fromValueTextField.text = "HRK"
        default:
            print("default")
        }
        
        picker.reloadAllComponents()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return homeViewModel.HNBdata.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return homeViewModel.HNBdata[row].currencyCode
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(homeViewModel.HNBdata[row].currencyCode)
        activeTextField.text = homeViewModel.HNBdata[row].currencyCode
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: true)
        
        fromValueTextField.inputAccessoryView = toolbar
        toValueTextField.inputAccessoryView = toolbar
    }
    
    
    @objc func doneClicked() {
        activeTextField.resignFirstResponder()
    }
    
    @objc func cancelClicked() {
        activeTextField.text = .empty
        activeTextField.resignFirstResponder()
    }
    
    @objc func calculateButtonTapped() {
        if (self.fromValueTextField.text != .empty && self.toValueTextField.text != .empty && self.inputTextField.text != .empty){
            
            resultLabel.text = homeViewModel.calculate(from: fromValueTextField.text!, to: toValueTextField.text!, value: inputTextField.text!)
            
        }else {
            ErrorAlert().alert(viewToPresent: self, title: "No values", message: "Some of the Input Values aren't filled!")
        }
    
    
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
        self.title = "UHP Zadatak"
        
        fromValueTextField.delegate = self
        toValueTextField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        fromValueTextField.inputView = picker
        toValueTextField.inputView = picker
        
        createToolbar()
        
        self.view.addSubview(fromValueTextField)
        fromValueTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        fromValueTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        fromValueTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(toValueTextField)
        toValueTextField.topAnchor.constraint(equalTo: fromValueTextField.topAnchor).isActive = true
        toValueTextField.leadingAnchor.constraint(equalTo: fromValueTextField.trailingAnchor, constant: 10).isActive = true
        toValueTextField.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: -8).isActive = true
        toValueTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(inputTextField)
        inputTextField.topAnchor.constraint(equalTo: fromValueTextField.bottomAnchor, constant: 8).isActive = true
        inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(calculateButton)
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        calculateButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 16).isActive = true
        calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        self.view.addSubview(resultLabel)
        resultLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 8).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
