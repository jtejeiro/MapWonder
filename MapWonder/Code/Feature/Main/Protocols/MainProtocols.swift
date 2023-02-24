//
//  MainProtocols.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//


// MARK: - View Protocol
protocol MainView: AnyObject {
    var presenter: MainPresenter? { get set }
    func configView()
    func reloadFilterView()
}

// MARK: - Presenter
protocol MainPresenter: AnyObject {
    
    var view: MainView? { get set }
    var interactor: MainInteractor? { get set }
    var router: MainRouter? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func reloadPoisApiClient()
    
    func getlistPoisCount() -> Int
    func getlistPoisList() -> [PoisAnnotation]
    func actionSearchBarButtonClicked(text: String)
}


// MARK: - Interactor
protocol MainInteractorCallback: AnyObject {
    func fetchedPoisApiClient()  async throws -> PoisResponse?
}

protocol MainInteractor: AnyObject {
    var presenter: MainInteractorCallback? { get set }
    func fetchPoisApiClient() async throws -> PoisResponse
    func getPoisSessionManager() -> PoisResponse?
    func removePoisSessionManager()
}

// MARK: - Router
protocol MainRouter: AnyObject {

}
