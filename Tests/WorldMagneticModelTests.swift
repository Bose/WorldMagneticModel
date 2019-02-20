//
//  WorldMagneticModelTests.swift
//  WorldMagneticModelTests
//
//  Copyright (c) 2019 Bose Corporation
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import CoreLocation
import WorldMagneticModel
import XCTest

class WorldMagneticModelTests: XCTestCase {
    private let model: WMMModel = {
        do {
            return try WMMModel()
        }
        catch {
            fatalError("Error loading mode: \(error)")
        }
    }()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day

        return Calendar.current.date(from: dc)!
    }

    private func location(_ latitude: Double, _ longitude: Double, _ altitude: Double) -> CLLocation {
        return CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                          altitude: altitude,
                          horizontalAccuracy: 0,
                          verticalAccuracy: 0,
                          timestamp: Date())
    }

    private struct WMMTestData {
        let date: Double
        let altitude: Double
        let latitude: Double
        let longitude: Double
        let decl: Double
        let incl: Double
        let h: Double
        let x: Double
        let y: Double
        let z: Double
        let f: Double
        let declDot: Double
        let inclDot: Double
        let hDot: Double
        let xDot: Double
        let yDot: Double
        let zDot: Double
        let fDot: Double

        init(_ date: Double,
             _ altitude: Double,
             _ latitude: Double,
             _ longitude: Double,
             _ decl: Double,
             _ incl: Double,
             _ h: Double,
             _ x: Double,
             _ y: Double,
             _ z: Double,
             _ f: Double,
             _ declDotMin: Double,
             _ inclDotMin: Double,
             _ hDot: Double,
             _ xDot: Double,
             _ yDot: Double,
             _ zDot: Double,
             _ fDot: Double)
        {
            self.date = date
            self.altitude = altitude
            self.latitude = latitude
            self.longitude = longitude
            self.decl = decl
            self.incl = incl
            self.h = h
            self.x = x
            self.y = y
            self.z = z
            self.f = f
            self.declDot = declDotMin / 60
            self.inclDot = inclDotMin / 60
            self.hDot = hDot
            self.xDot = xDot
            self.yDot = yDot
            self.zDot = zDot
            self.fDot = fDot
        }
    }

    func testTestValues() {
        // Five test points manually run through wmm_file.c (modified to output decl and incl as decimal degrees instead of degrees and minutes).
        let data: [WMMTestData] = [
            //          Date    Altitude  Latitude    Longitude   D      I      H_nT     X_nT     Y_nT     Z_nT      F_nT     dD_min dI_min dH_nT  dX_nT  dY_nT  dZ_nT   dF_nT
            WMMTestData(2018.7,  97.0,     42.301615, -71.479065, -14.3,  67.1, 20250.1, 19619.2, -5015.4,  47837.5, 51947.0,  5.0,   -6.2,  48.7,  54.4,  16.2, -124.7, -95.9),
            WMMTestData(2018.7,  18.0,     51.500547,  -0.124607,  -0.2,  66.5, 19499.6, 19499.5,   -75.1,  44759.0, 48822.2, 11.3,    0.1,  13.5,  13.8,  63.9,   35.2,  37.7),
            WMMTestData(2018.7,  48.0,     39.904493, 116.391380,  -7.0,  59.1, 28082.7, 27873.0, -3425.3,  46925.6, 54686.9, -5.9,    3.2, -19.8, -25.5, -45.2,   65.8,  46.3),
            WMMTestData(2018.7,  15.0,    -33.856273, 151.215345,  12.6, -64.3, 24753.7, 24160.5,  5386.7, -51404.3, 57054.0,  0.5,   -0.3,  -7.4,  -8.0,   1.7,    4.7,  -7.4),
            WMMTestData(2018.7, 148.0,    -22.949616, -43.153568, -22.8, -40.6, 17631.5, 16258.4, -6821.7, -15099.0, 23213.1, -4.3,  -21.3, -96.3, -97.4,  16.9, -107.3,  -3.4)
        ]

        for tc in data {
            let location = self.location(tc.latitude, tc.longitude, tc.altitude)
            let date = WMMDate(decimalYear: tc.date)
            let result = model.elements(for: location, wmmDate: date)

            print("Testing at \(tc.latitude), \(tc.longitude)")

            let acc = 0.05
            XCTAssertEqual(result.x, tc.x, accuracy: acc)
            XCTAssertEqual(result.y, tc.y, accuracy: acc)
            XCTAssertEqual(result.z, tc.z, accuracy: acc)
            XCTAssertEqual(result.h, tc.h, accuracy: acc)
            XCTAssertEqual(result.f, tc.f, accuracy: acc)
            XCTAssertEqual(result.incl, tc.incl, accuracy: acc)
            XCTAssertEqual(result.decl, tc.decl, accuracy: acc)
            XCTAssertEqual(result.xDot, tc.xDot, accuracy: acc)
            XCTAssertEqual(result.yDot, tc.yDot, accuracy: acc)
            XCTAssertEqual(result.zDot, tc.zDot, accuracy: acc)
            XCTAssertEqual(result.hDot, tc.hDot, accuracy: acc)
            XCTAssertEqual(result.fDot, tc.fDot, accuracy: acc)
            XCTAssertEqual(result.inclDot, tc.inclDot, accuracy: acc)
            XCTAssertEqual(result.declDot, tc.declDot, accuracy: acc)
        }
    }

    private struct WMM2015TestData {
        let date: Double
        let height: Double
        let lat: Double
        let lon: Double
        let x: Double
        let y: Double
        let z: Double
        let h: Double
        let f: Double
        let i: Double
        let d: Double
        let gv: Double
        let xDot: Double
        let yDot: Double
        let zDot: Double
        let hDot: Double
        let fDot: Double
        let iDot: Double
        let dDot: Double

        init(_ date: Double,
             _ height: Double,
             _ lat: Double,
             _ lon: Double,
             _ x: Double,
             _ y: Double,
             _ z: Double,
             _ h: Double,
             _ f: Double,
             _ i: Double,
             _ d: Double,
             _ gv: Double,
             _ xDot: Double,
             _ yDot: Double,
             _ zDot: Double,
             _ hDot: Double,
             _ fDot: Double,
             _ iDot: Double,
             _ dDot: Double)
        {
            self.date = date
            self.height = height
            self.lat = lat
            self.lon = lon
            self.x = x
            self.y = y
            self.z = z
            self.h = h
            self.f = f
            self.i = i
            self.d = d
            self.gv = gv
            self.xDot = xDot
            self.yDot = yDot
            self.zDot = zDot
            self.hDot = hDot
            self.fDot = fDot
            self.iDot = iDot
            self.dDot = dDot
        }
    }

    func testWMM2015TestValues() {
        // Test data is extracted from the table in TestValues2015v2.pdf
        let data: [WMM2015TestData] = [
            WMM2015TestData(2015, 0, 80, 0, 6636.6, -451.9, 54408.9, 6651.9, 54814, 83.03, -3.9, -3.9, -12.6, 61.3, 39, -16.7, 36.7, 0.02, 0.52),
            WMM2015TestData(2015, 0, 0, 120, 39521.1, 377.7, -11228.8, 39522.9, 41087.1, -15.86, 0.55, 0.55, 19.3, -50.2, 64.3, 18.8, 0.5, 0.09, -0.07),
            WMM2015TestData(2015, 0, -80, 240, 5796.3, 15759.1, -52927.1, 16791.2, 55526.8, -72.4, 69.81, 309.81, 27.3, 2, 88.4, 11.3, -80.8, 0.04, -0.09),
            WMM2015TestData(2015, 100, 80, 0, 6323.4, -477.6, 52249.1, 6341.4, 52632.5, 83.08, -4.32, -4.32, -11.6, 58.6, 35.5, -16, 33.3, 0.02, 0.52),
            WMM2015TestData(2015, 100, 0, 120, 37538.1, 351.1, -10751.1, 37539.7, 39048.9, -15.98, 0.54, 0.54, 18.5, -46.1, 60.2, 18.1, 0.8, 0.09, -0.07),
            WMM2015TestData(2015, 100, -80, 240, 5612.2, 14789.3, -50385.8, 15818.3, 52810.5, -72.57, 69.22, 309.22, 25.1, 1.5, 82.5, 10.3, -75.6, 0.04, -0.08),
            WMM2015TestData(2017.5, 0, 80, 0, 6605.2, -298.7, 54506.3, 6612, 54905.9, 83.08, -2.59, -2.59, -12.6, 61.3, 39, -15.3, 36.9, 0.02, 0.53),
            WMM2015TestData(2017.5, 0, 0, 120, 39569.4, 252.3, -11067.9, 39570.2, 41088.9, -15.63, 0.37, 0.37, 19.3, -50.2, 64.3, 19, 1, 0.09, -0.07),
            WMM2015TestData(2017.5, 0, -80, 240, 5864.6, 15764.1, -52706.1, 16819.7, 55324.8, -72.3, 69.59, 309.59, 27.3, 2, 88.4, 11.4, -80.7, 0.04, -0.08),
            WMM2015TestData(2017.5, 100, 80, 0, 6294.3, -331.1, 52337.8, 6303, 52716, 83.13, -3.01, -3.01, -11.6, 58.6, 35.5, -14.7, 33.5, 0.02, 0.53),
            WMM2015TestData(2017.5, 100, 0, 120, 37584.4, 235.7, -10600.5, 37585.1, 39051.4, -15.75, 0.36, 0.36, 18.5, -46.1, 60.2, 18.2, 1.2, 0.09, -0.07),
            WMM2015TestData(2017.5, 100, -80, 240, 5674.9, 14793.1, -50179.5, 15844.2, 52621.5, -72.48, 69.01, 309.01, 25.1, 1.5, 82.5, 10.4, -75.6, 0.04, -0.08)
        ]

        for tc in data {
            var result: WMMElements?
            let altitude = tc.height * 1000 // test case altitude is in kilometers, CLLocation is in meters
            let location = self.location(tc.lat, tc.lon, altitude)
            let date = WMMDate(decimalYear: tc.date)
            model.compute(for: location, altitudeMode: .aboveWGS84Ellipsoid, wmmDate: date, result: &result, uncertainty: nil)

            let acc = 0.05
            XCTAssertEqual(result!.x, tc.x, accuracy: acc)
            XCTAssertEqual(result!.y, tc.y, accuracy: acc)
            XCTAssertEqual(result!.z, tc.z, accuracy: acc)
            XCTAssertEqual(result!.h, tc.h, accuracy: acc)
            XCTAssertEqual(result!.f, tc.f, accuracy: acc)
            XCTAssertEqual(result!.incl, tc.i, accuracy: acc)
            XCTAssertEqual(result!.decl, tc.d, accuracy: acc)
            XCTAssertEqual(result!.gv, tc.gv, accuracy: acc)
            XCTAssertEqual(result!.xDot, tc.xDot, accuracy: acc)
            XCTAssertEqual(result!.yDot, tc.yDot, accuracy: acc)
            XCTAssertEqual(result!.zDot, tc.zDot, accuracy: acc)
            XCTAssertEqual(result!.hDot, tc.hDot, accuracy: acc)
            XCTAssertEqual(result!.fDot, tc.fDot, accuracy: acc)
            XCTAssertEqual(result!.inclDot, tc.iDot, accuracy: acc)
            XCTAssertEqual(result!.declDot, tc.dDot, accuracy: acc)
        }
    }
}
