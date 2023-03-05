//
//  MainPresenterImpl.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//
import UIKit
import Foundation
import Combine

@MainActor
class MainPresenterImpl{
    
    // MARK: - Properties
    weak var view: MainView?
    var interactor: MainInteractor?
    var router: MainRouter?
    
    // MARK: - Var
    var viewModel:MainViewModel!
    
    @Published
    var textFilter:String = ""
    
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        subscribeFilter()
    }
    
}
// MARK: - MainPresenter methods
extension MainPresenterImpl: MainPresenter {
 
    func viewDidLoad() {
        Task {
            let poisResponse = try await fetchedPoisApiClient()
            setPoisApiClient(model: poisResponse)
        }
      
    }
    
    func viewWillAppear() {
    }
    
    func viewDidAppear() {

    }
    
    func getlistPoisCount() -> Int {
        return getlistPoisList().count
    }
    
    func getlistPoisList() -> [PoisAnnotation] {
        let listPois = viewModel.listPois
        
        if getTextFilter() != "" {
            return listPois.filter(({ $0.title?.lowercased().hasPrefix(getTextFilter()) ?? false }))
        }
        return listPois
    }
    
    func reloadPoisApiClient() {
        interactor?.removePoisSessionManager()
        Task {
            if let poisResponse = try await fetchedPoisApiClient() {
                setPoisApiClient(model: poisResponse)
            }
        }
    }
    
    func actionSearchBarButtonClicked(text: String) {
        if viewModel != nil {
            setTextFilter(text)
            view?.reloadFilterView()
        }
    }
    
}
// MARK: - ListUserInteractorCallback methods
extension MainPresenterImpl: MainInteractorCallback {
    func fetchedPoisApiClient() async throws -> PoisResponse? {
        do{
            let poisResponse = try await interactor?.fetchPoisApiClient()
            return poisResponse
        }catch{
            return nil
        }
    }
}


// MARK: - Private methods
private extension MainPresenterImpl {
    
    func subscribeFilter(){
        $textFilter
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { value in
                print(value)
            self.actionSearchBarButtonClicked(text: value)
        }.store(in: &cancellables)
    }
    
    func setTextFilter(_ text:String){
        self.textFilter = text
    }
    
    func getTextFilter() -> String {
        return textFilter.lowercased()
    }
    
    func setPoisApiClient(model:PoisResponse?){
        if let poislist = model?.list {
            self.viewModel = MainViewModel.mapToDomainModel(model: poislist)
            view?.configView()
        }
    }
    
}

