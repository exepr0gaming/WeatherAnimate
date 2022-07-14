//
//  HomeView.swift
//  WeatherAnimate
//
//  Created by Курдин Андрей on 11.07.2022.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
	case top = 0.83 // 702/844
	case middle = 0.385 // 325/844
}

struct HomeView: View {
	
	@State var bottomSheetPosition: BottomSheetPosition = .middle
	@State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
	@State var hasDragged: Bool = false
	
		// чтобы с 0.385 и 0.83 сделать с 0 до 1
	var bottomSheetTranslationProrated: CGFloat {
		(bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
	}
	
    var body: some View {
			NavigationView {
				GeometryReader { geometry in
					
					let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
					let imageOffset = screenHeight + 36
					
					ZStack {
						Color.background
							.ignoresSafeArea()
						
						Image("Background")
							.resizable()
							.ignoresSafeArea()
							.offset(y: -bottomSheetTranslationProrated * imageOffset)
						
						Image("House")
							.frame(maxHeight: .infinity, alignment: .top)
							.padding(.top, 257)
							.offset(y: -bottomSheetTranslationProrated * imageOffset)
						
						// MARK: - Current Weather
						VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
							Text("Montreal")
								.font(.largeTitle)
							
							VStack {
								Text(attributedStr)
								
								Text("H:24°   L:18°")
									.font(.title3.weight(.semibold))
									.opacity(1 - bottomSheetTranslationProrated)
							}
							
							Spacer()
						}
						.padding(.top, 51)
						.offset(y: -bottomSheetTranslationProrated * 46)
						
						// MARK: - Bottom Sheet
						BottomSheetView(position: $bottomSheetPosition) {
							//Text(bottomSheetPosition.rawValue.formatted())
						//	Text(bottomSheetTranslation.formatted())
							//Text(bottomSheetTranslationProrated.formatted())
						} content: {
							ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
						}
						.onBottomSheetDrag { translation in
							bottomSheetTranslation = translation / screenHeight
							
							withAnimation(.easeInOut) {
								hasDragged = bottomSheetPosition == .top ? true : false
							}
						}
						
						// MARK: - Tab Bar
						TabBar(action: {
							bottomSheetPosition = .top
						})
							.offset(y: bottomSheetTranslationProrated * 115)
					}
				}
				.navigationBarHidden(true)
				
			}
    }
}

extension HomeView {
	private var attributedStr: AttributedString {
		var str = AttributedString("19°" + (hasDragged ? " | " : "\n ") + "Mostly Clear")
		if let temp = str.range(of: "19°") {
			str[temp].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))),
															 weight: hasDragged ? .semibold : .thin)
			str[temp].foregroundColor = hasDragged ? .secondary : .primary
		}
		if let pipe = str.range(of: " | ") {
			str[pipe].font = .title3.weight(.semibold)
			str[pipe].foregroundColor = .secondary.opacity(bottomSheetTranslationProrated)
		}
		if let weather = str.range(of: "Mostly Clear") {
			str[weather].font = .title3.weight(.semibold)
			str[weather].foregroundColor = .secondary
		}
		return str
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
			HomeView()
				.preferredColorScheme(.dark)
    }
}
