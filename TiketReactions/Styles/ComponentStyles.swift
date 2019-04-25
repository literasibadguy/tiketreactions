//
//  BaseStyles.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public enum Styles {
    public static let cornerRadius: CGFloat = 4.0
    
    public static func grid(_ count: Int) -> CGFloat {
        return 6.0 * CGFloat(count)
    }
    
    public static func gridHalf(_ count: Int) -> CGFloat {
        return grid(count) / 2.0
    }
}

public func baseControllerStyle<VC: UIViewControllerProtocol> () -> ((VC) -> VC) {
    return VC.lens.view.backgroundColor .~ .tk_base_grey_100
        <> (VC.lens.navigationController..navBarLens) %~ { view in view.map(baseNavigationBarStyle) }
}

public func baseTableControllerStyle<TVC: UITableViewControllerProtocol> (estimatedRowHeight: CGFloat = 480.0) -> ((TVC) -> TVC) {
    let style = baseControllerStyle()
        <> TVC.lens.view.backgroundColor .~ .tk_base_grey_100
        <> TVC.lens.tableView.rowHeight .~ UITableView.automaticDimension
        <> TVC.lens.tableView.estimatedRowHeight .~ estimatedRowHeight
    
    #if os(iOS)
        return style <> TVC.lens.tableView.separatorStyle .~ .none
    #else
        return
    #endif
}


public func baseTableViewCellStyle <TVC: UITableViewCellProtocol> () -> ((TVC) -> TVC) {
    
    return
        TVC.lens.contentView.layoutMargins %~~ { _, cell in
            if cell.traitCollection.isRegularRegular {
                return .init(topBottom: Styles.grid(3), leftRight: Styles.grid(12))
            }
            return .init(topBottom: Styles.grid(1), leftRight: Styles.grid(2))
            }
            <> TVC.lens.backgroundColor .~ .white
            <> (TVC.lens.contentView..UIView.lens.preservesSuperviewLayoutMargins) .~ false
            <> TVC.lens.layoutMargins .~ .init(all: 0.0)
            <> TVC.lens.preservesSuperviewLayoutMargins .~ false
            <> TVC.lens.selectionStyle .~ .none
}

public func baseActivityIndicatorStyle(indicator: UIActivityIndicatorView) -> UIActivityIndicatorView {
    return indicator
        |> UIActivityIndicatorView.lens.hidesWhenStopped .~ true
        |> UIActivityIndicatorView.lens.style .~ .white
        |> UIActivityIndicatorView.lens.color .~ .gray
}

public func cardStyle <V: UIViewProtocol> (cornerRadius radius: CGFloat = 0) -> ((V) -> V) {
    return roundedStyle(cornerRadius: radius)
        <> V.lens.layer.borderColor .~ UIColor.clear.cgColor
        <> V.lens.layer.borderWidth .~ 0
        <> V.lens.backgroundColor .~ .white
}

public let feedTableViewCellStyle = baseTableViewCellStyle()
    <> UITableViewCell.lens.contentView.layoutMargins %~~ { _, cell in
        cell.traitCollection.isRegularRegular
            ? .init(topBottom: Styles.grid(2), leftRight: Styles.grid(30))
            : .init(topBottom: Styles.gridHalf(3), leftRight: Styles.grid(2))
}


public let separatorStyle =
    UIView.lens.backgroundColor .~ .tk_base_grey_100
        <> UIView.lens.accessibilityElementsHidden .~ true


public func roundedStyle <V: UIViewProtocol> (cornerRadius r: CGFloat = Styles.cornerRadius) -> ((V) -> V) {
    return V.lens.clipsToBounds .~ true
        <> V.lens.layer.masksToBounds .~ true
        <> V.lens.layer.cornerRadius .~ r
}

private let navBarLens: Lens<UINavigationController?, UINavigationBar?> = Lens(
    view: { view in view?.navigationBar },
    set: { _, set in set }
)

private let baseNavigationBarStyle =
    UINavigationBar.lens.titleTextAttributes .~ [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)
        ]
        <> UINavigationBar.lens.translucent .~ false
        <> UINavigationBar.lens.barTintColor .~ .white
        <> UINavigationBar.lens.tintColor .~ .tk_official_green

