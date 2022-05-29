//
//  Repository.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 09.05.2022.
//


import UIKit
import CoreData
import RxSwift
import RxCocoa

protocol RepositoryProtocol {
    var networkRequestResult: PublishSubject<[Request]> { get }
    func loadCallHistory()
}

class Repository: RepositoryProtocol {
    
    var networkRequestResult = PublishSubject<[Request]>()
    
    func loadCallHistory() {
        NetworkRequest.shared.loadCalls(url: "https://5e3c202ef2cb300014391b5a.mockapi.io/testapi") { [weak self] result in
            switch result {
            case .success(let calls):
                DispatchQueue.main.async() {
                    self?.saveToStorage(calls)
                    self?.networkRequestResult.on(.next(calls))
                }
            case .failure(let error):
                print("failed to load data from server:\n\(error.localizedDescription)\n will try loading from local storage\n")
                DispatchQueue.main.async {
                    if let calls = self?.loadFromStorage() {
                        self?.networkRequestResult.on(.next(calls))
                    } else {
                        self?.networkRequestResult.on(.next([Request]()))
                    }
                }
            }
        }
    }
    
    private func saveToStorage(_ callList: [Request]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Call")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        //erase existing data
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Error while deleting data. \(error), \(error.userInfo)")
        }
        
        //write new data
        for (index, call) in callList.enumerated() {
            Call(context: managedContext, request: call, order: index)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error while saving data. \(error), \(error.userInfo)")
        }
    }
    

    private func loadFromStorage() -> [Request]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Call> = Call.fetchRequest()
        
        do {
            let recentCalls = try managedContext.fetch(request)
            let calls = recentCalls
                .sorted(by: { $0.order < $1.order })
                .map({
                $0.getCallInfo()
            })
            return calls
        } catch let error as NSError {
          print("Error while fetching data from storage. \(error), \(error.userInfo)")
        }
        return nil
    }
    
}
