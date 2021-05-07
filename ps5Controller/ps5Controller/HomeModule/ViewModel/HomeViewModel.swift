struct HomeViewModel {
    let title: String
    let subtitle: String
    let image: String
    
    init?(title: String?, subtitle: String?, image: String?) {
        guard let title = title, let subtitle = subtitle, let image = image else { return nil }
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
