import UIKit

class BadgeButton: UIButton {
    private var badgeLabel: UILabel!
    
    var badgeValue: String? {
        didSet {
            badgeLabel.isHidden = badgeValue == nil
            badgeLabel.text = badgeValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBadge()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBadge()
    }
    
    private func setupBadge() {
        let badgeSize: CGFloat = 20
        let badgeOriginX = bounds.width - badgeSize / 2
        let badgeOriginY = -badgeSize / 2
        
        badgeLabel = UILabel(frame: CGRect(x: badgeOriginX, y: badgeOriginY, width: badgeSize, height: badgeSize))
        badgeLabel.layer.cornerRadius = badgeSize / 2
        badgeLabel.layer.masksToBounds = true
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = .black
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(badgeLabel)
        badgeLabel.isHidden = true
    }
}
