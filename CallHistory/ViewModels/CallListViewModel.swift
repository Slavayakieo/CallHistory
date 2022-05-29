//
//  CallListViewModel.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 04.05.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol CallListViewModelProtocol: NSObject {
    var calls: BehaviorRelay<[Request]> { get }
    var callsCount: Int { get }
    func fetchData()
    
    func cellViewModel(for row: Int) -> InfoCellViewModel
    func businessInfoViewModel(for row: Int) -> BottomSheetViewModelProtocol
    
}

class CallListViewModel: NSObject, CallListViewModelProtocol {
    var calls = BehaviorRelay<[Request]>(value: [])
    
    var callsCount: Int {
        calls.value.count
    }
    
    private let bag = DisposeBag()
    private let repository: RepositoryProtocol
    
    override init() {
        self.repository = Repository()
        super.init()
        bindInput()
    }
    
    func bindInput() {
        repository.networkRequestResult.subscribe(onNext: {  [weak self] calls in
            self?.calls.accept(calls)
        }).disposed(by: bag)
    }
    
    func cellViewModel(for row: Int) -> InfoCellViewModel {
        return InfoCellViewModel(call: calls.value[row])
    }
    
    func businessInfoViewModel(for row: Int) -> BottomSheetViewModelProtocol {
        return BusinessInfoViewModel(businessNumber: calls.value[row].businessNumber)
    }
    
    func fetchData() {
        repository.loadCallHistory()
    }
    
}
