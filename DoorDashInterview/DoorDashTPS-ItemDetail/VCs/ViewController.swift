import UIKit
import Combine

//TODO Enum for all possibilities when we add combine
enum FetchType {
    case standard
    case codable
    case combine
    case aa
}

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    //MARK: Properties
    let contentService = ContentService()
    
    var feedTable : UITableView = {
        let tbl = UITableView(frame: .zero)
        tbl.backgroundColor = .clear
        return tbl
    }()
    
    var feedItems : [[String : Any]] = [[:]] //w/o codable
    var contentItems : [ContentItem] = [] //codable
    
    var mainImageURLString : String = "" //"header_image_url" not nested in "content_items"
    
    //Store / get rid of observation
    typealias TokenSet = Set<AnyCancellable>
    
    //A type-erasing cancellable object that executes a provided closure when canceled.
    var tokens = TokenSet()
    var fetchType = FetchType.standard // default
    
    var codableMode : Bool = false {
        didSet {
            self.reloadOnMainQueue()
        }
    }
    
    var imagePresenter : ImagePresenter = {
        let ip = ImagePresenter()
        return ip
    }()

    //MARK: Lifecycle begin
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        view.backgroundColor = .white
        // self.gradientForView(self.view, .white, .lightGray)
    }
    
    //Can discard this?
    @objc fileprivate func codableToggle() {
        codableMode = !codableMode
    }
    
    //MARK: fileprivate = private to file whereas private = private to type
    
    fileprivate func configureTable() {
        feedTable.register(FeedCell.self, forCellReuseIdentifier: "feedCell")
        feedTable.register(ImageHeaderCell.self, forCellReuseIdentifier: "imageCell")
        feedTable.register(MethodChoiceScrollPicker.self, forCellReuseIdentifier: "headerCell")
        
        view.addSubview(feedTable)
        feedTable.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        feedTable.layer.cornerRadius = 10
        feedTable.layer.borderColor = UIColor.black.cgColor
        
        feedTable.delegate = self
        feedTable.dataSource = self
        
        //MARK: Image picker
        view.addSubview(imagePresenter)
        imagePresenter.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 50, paddingBottom: 50, paddingRight: 50, width: 0, height: 0)
        imagePresenter.delegate = self
        imagePresenter.isHidden = true
        imagePresenter.layer.cornerRadius = 5
        imagePresenter.layer.masksToBounds = false
    }
    
    
    fileprivate func dataFetcherWithType(_ theFetchType: FetchType) {
        let path = Bundle.main.path(forResource: "Content", ofType: "json")!
        switch theFetchType {
        case .standard:
            self.fetchDataStandard(path)
        case .codable:
            self.fetchDataCodable(path)
        case .combine:
            self.fetchDataCombine(path)
        case .aa:
            self.fetchDataAA(path)
        }
    }
    
    fileprivate func fetchDataStandard(_ path: String) {
        let preFetchTime = Date()
        ContentService.fetchJSONData(path) { feedModels, theError in
            //Check for error
            guard let feed = feedModels else {
                return //Don't want this? If let would be better with DG
            }
            print("FEED JSON \(feed)")
            //TODO also fetch header URL
            self.feedItems = feed["content_items"] as? [[String : Any]] ?? [[:]]
            self.mainImageURLString = feed["header_image_url"] as? String ?? ""
            
            let postFetchTime = Date()
            let timeTakenStandard = TimeSpaceMeasurer.calculateTimeOfExecution(preFetchTime, postFetchTime)
            print("Time taken standard \(timeTakenStandard)")
            
            self.reloadOnMainQueue()
        }
    }
    
    fileprivate func fetchDataCodable(_ path: String) {
        ContentService.fetchCodableJSONData(path) { feedModels, error in
            //TODO handle error
            guard let feed = feedModels else {
                return
            }
            print("FEED JSON CODABLE \(feed)")
            self.contentItems = feedModels?.content_items ?? []
            self.mainImageURLString = feedModels?.header_image_url ?? ""
            
            self.reloadOnMainQueue()
        }
    }
    
    fileprivate func fetchDataCombine(_ path: String) {
        //MARK: sink = Attaches a subscriber with closure-based behavior.
        //assign =
        let someContent: () = ContentService.fetchDataCombine(path).sink { error in
            print("Error from combine call \(error)")
            //NOTE: This just prints "finished" but there's no error
        } receiveValue: { dictionary in
            print("Dict from Combine call \(dictionary)")
        }.store(in: &tokens)

        print("Some Content \(someContent)")
    }
    
    fileprivate func fetchDataAA(_ path: String) {
        //MARK: A unit of asynchronous work.
        Task {
            await feedDataAsyncAwait(path)
        }
    }
    
    //Source: Apple
    //Both the sink(receiveCompletion:receiveValue:) and assign(to:on:) subscribers request an unlimited number of elements from their publishers. To control the rate at which you receive elements, create your own subscriber by implementing the Subscriber protocol.
    
    fileprivate func feedDataAsyncAwait(_ path: String) async {
        let feedData = try? await ContentService.fetchDataAsyncAwait(path)
        print("FEED DATA AA \(String(describing: feedData))")
    }
    
    fileprivate func reloadOnMainQueue() {
        DispatchQueue.main.async {
            self.feedTable.reloadData()
        }
    }
    
    fileprivate func imagePresentHandler(_ imageString: String) {
        imagePresenter.mainImageString = imageString
        imagePresenter.isHidden = false
        handleAlphaOnImagePresent(false)
    }
    
    fileprivate func handleAlphaOnImagePresent(_ willHide: Bool) {
        for theView in view.subviews {
            if !theView.isKind(of: ImagePresenter.self) {
                theView.alpha = willHide ? 1 : 0.7
                theView.isUserInteractionEnabled = willHide
            }
        }
    }
    
    //Ideally move to utils file and not have in VC
    fileprivate func gradientForView(_ theView: UIView, _ topColor: UIColor, _ bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = theView.bounds
        theView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: Lifecycle end
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Remove any cancellable?
        tokens.removeAll()
    }
}

//MARK: TBL Del + DS

typealias TableFunctions = UITableViewDataSource & UITableViewDelegate

@available(iOS 13.0, *)
extension ViewController: TableFunctions {
    //MARK: Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! MethodChoiceScrollPicker
        headerCell.delegate = self
        headerCell.setUpFetchWrapper()
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 180 : 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageHeaderCell
            imageCell.setUpViews()
            //MARK: Header image, not nested
            if self.mainImageURLString != "" {
                //Should try
                //Also check Core Data
                imageCell.populate(withURL: URL(string: mainImageURLString)!)
            }
            return imageCell
            
        } else {
        
            let theCell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedCell
            theCell.setUpViews()
        
            //MARK: NOTE: Usually a reference to self should be weak in these closures due to mutual / prolonged retention (between self and the closure)
            
            theCell.actionPublisher.sink(receiveValue: { [weak self] action in
                switch action {
                case .showContent(let theItem):
                    print("ACTION PUBLISHER SUCCESS \(theItem) SELF \(String(describing: self))")
                    self?.imagePresentHandler(theItem.image_url)
                }
            }).store(in: &tokens) //Stores this type-erasing cancellable instance in the specified set.
        
            //MARK: can wrap this function outside of cellForRow
            switch fetchType {
                case .standard:
                    let fiAtIP = feedItems[indexPath.row - 1]
                    theCell.populate(with: fiAtIP)
                case .codable:
                    let ciAtIP = contentItems[indexPath.row - 1]
                    theCell.populate(with: ciAtIP)
                case .combine:
                    print("COMBINE CLAUSE")
                case .aa:
                    print("AA CLAUSE")
            
            //MARK: This is only necessary when every possibility of the enum doesn't get tested
            //            default:
            //                print("DEFAULT CLAUSE")
            }
            return theCell
        }
    }
    
    //MARK: + 1 will be main image
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codableMode == true ? contentItems.count + 1 : feedItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

@available(iOS 13.0, *)
extension ViewController: DidChooseOption, DidCloseImagePresenter {
    
    //MARK: Scroll
    func choseOption(index: Int) {
        print("INDEX \(index)")
        switch index {
            case 0:
                fetchType = .standard
            case 1:
                fetchType = .codable
            case 2:
                fetchType = .combine
            case 3:
                fetchType = .aa
        default:
            print("Nothing")
        }
        //Fetch accordingly
        self.dataFetcherWithType(fetchType)
    }
    
    //MARK: IP
    func didClickClose() {
        imagePresenter.isHidden = true
        handleAlphaOnImagePresent(true)
    }
}

