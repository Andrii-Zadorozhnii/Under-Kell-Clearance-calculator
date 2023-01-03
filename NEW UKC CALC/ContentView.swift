//
//  ContentView.swift
//  NEW UKC CALC
//
//  Created by Andrii Zadorozhnii on 15.09.2022.

import SwiftUI

struct ContentView: View {
    
    // @State Private vars
    
    @State private var lbp = ""
    @State private var vesselLenght = ""
    @State private var vesselBeam = ""
    @State private var displacement = ""
    
    @State private var chartedWaterDepth = ""
    @State private var soundingDatumAllowance = ""
    @State private var tideHeight = ""
    
    @State private var maxVesselDraft = ""
    
    @State private var catzocError = ""
    @State private var rollingDeg = ""
    @State private var pitchingDeg = ""
    @State private var seaWaterDensityAllowance = ""
    @State private var otherFactors = ""
    @State private var maximumSafeSpeed = ""
    @State private var selectedCatzoc = 0
    
    // Calculation area
    
    var availableWaterDepths : Double {
        let tideCount = (Double(chartedWaterDepth) ?? 0.0) - (Double(soundingDatumAllowance) ?? 0.0 ) + (Double(tideHeight) ?? 0.0)
        return tideCount
    }
    //CATZOC
    
    var catzoc = ["A1","A2","B","C","D","U"]
    
    var catzocSelected : Double {
        let maxVesselDraftDouble = Double(maxVesselDraft) ?? 0.0
        if selectedCatzoc == 0{
            let catzocError = (maxVesselDraftDouble/100.0) * 10.0
            return catzocError
        }else if selectedCatzoc == 1{
            let catzocError = (maxVesselDraftDouble/100.0) * 10.0
            return catzocError
        }else if  selectedCatzoc == 2{
            let catzocError = (maxVesselDraftDouble/100.0) * 15.0
            return catzocError
        }else if  selectedCatzoc == 3{
            let catzocError = (maxVesselDraftDouble/100.0) * 25.0
            return catzocError
        }else if selectedCatzoc == 4{
            let catzocError = (maxVesselDraftDouble/100.0) * 25.0
            return catzocError
        }else if selectedCatzoc == 5{
            let catzocError = (maxVesselDraftDouble/100.0) * 50.0
            return catzocError
        }
        return Double(catzocError) ?? 0.0
    }
    
    var catzocFactor : Double {
        if selectedCatzoc == 0 {
            let catzocError = 0.815
            return catzocError
        }else if selectedCatzoc == 1{
            let catzocError = 0.815
            return catzocError
        }else if  selectedCatzoc == 2{
            let catzocError = 0.811
            return catzocError
        }else if  selectedCatzoc == 3{
            let catzocError = 0.8
            return catzocError
        }else if selectedCatzoc == 4{
            let catzocError = 0.8
            return catzocError
        }else if selectedCatzoc == 5{
            let catzocError = 0.8
            return catzocError
        }
        return Double(catzocError) ?? 0.0
    }
    var catzocErrorPersent : Double {
        if selectedCatzoc == 0 {
            let catzocError = 0.1
            return catzocError
        }else if selectedCatzoc == 1{
            let catzocError = 0.1
            return catzocError
        }else if  selectedCatzoc == 2{
            let catzocError = 0.15
            return catzocError
        }else if  selectedCatzoc == 3{
            let catzocError = 0.25
            return catzocError
        }else if selectedCatzoc == 4{
            let catzocError = 0.25
            return catzocError
        }else if selectedCatzoc == 5{
            let catzocError = 0.5
            return catzocError
        }
        return Double(catzocError) ?? 0.0
    }
    
    
    // Cb calculation
    
    var cb : Double {
        let displacementCalculation = (Double(displacement) ?? 0)
        let lbpCalculation = (Double(lbp) ?? 0.1)
        let vesselBeamDouble = (Double(vesselBeam) ?? 0.1)
        let maxVesselDraftDouble = (Double(maxVesselDraft) ?? 0.0001)
        let cbcalculation : Double = displacementCalculation / (lbpCalculation * vesselBeamDouble * maxVesselDraftDouble)
        return cbcalculation
    }
    // Vessel Rolling Error
    
    var rollingError : Double {
        let rollingError = 0.5 * (((Double(vesselBeam) ?? 0.00001)) * (tan(((Double(rollingDeg) ?? 0.000001) * .pi) / 180)))
        return rollingError
    }
    
    // Vessel Pitchin Error
    
    var pitchingError : Double {
        let pitchingError = 0.5 * (Double(vesselLenght) ?? 0.000001) * (tan((Double(pitchingDeg) ?? 0.000001) * .pi) / 180)
        return pitchingError
    }
    


    
    // UKC Calculation
    
    var ukc : Double {
        let ukc = availableWaterDepths - deepestDynamicDraft
        return ukc
    }
    
    // Maximum Safe Speed
    
    var mmaximumSafeSpeed : Double {
        let chartedWaterDepthDouble = Double(chartedWaterDepth) ?? 0.0
        let tideHeightDouble = Double(tideHeight) ?? 0.0
        let soundingDatumDouble = Double(soundingDatumAllowance) ?? 0.0
        let maxVesselDraftDouble = Double(maxVesselDraft) ?? 0.0
        let otherFactorsDouble = Double(otherFactors) ?? 0.0
        let seaWaterDensityAllowanceDouble = Double(seaWaterDensityAllowance) ?? 0.0
        
        let maximumSafeSpeed = sqrt(((chartedWaterDepthDouble + tideHeightDouble - otherFactorsDouble-((maxVesselDraftDouble + rollingError + pitchingError + otherFactorsDouble + seaWaterDensityAllowanceDouble) + (maxVesselDraftDouble + rollingError + pitchingError + otherFactorsDouble + seaWaterDensityAllowanceDouble) * catzocErrorPersent)) * 100.0 / (2.0 * cb)) * catzocFactor + 0.342 * (0.5 - catzocErrorPersent))
        return maximumSafeSpeed
        }
    
    // Vessel Squat Calculation
    
    var squat : Double {
//        if (Double(chartedWaterDepth) ?? 0.1) < ((Double(maxVesselDraft) ?? 0.0) * 2.5){
        let squat = ((2.0 * cb) * (mmaximumSafeSpeed * mmaximumSafeSpeed) / 100.0)
        return squat
//        }else {
//            let squat = ((cb) * ((Double(maximumSafeSpeed) ?? 0.0) * (Double(maximumSafeSpeed) ?? 0.0)) / 100.0)
//            return squat
//        }
    }
    
    // Deepest Dynamic Draft Calculation
    
    var deepestDynamicDraft : Double {
        let deepestDynamicDraft = (Double(maxVesselDraft) ?? 0.0) + rollingError + pitchingError + (Double(otherFactors) ?? 0.0) + squat
        return deepestDynamicDraft
    }
    
                                    
//View
                                    
    var body: some View {
            NavigationView{
                Form{
                    Section{
                        HStack{
                            Text("Displacement (mt): ")
                            TextField("Enter", text: $displacement)
                                .frame(width: 80.0)
                        }
                        HStack{
                            Text("Vessel LBP (m): ")
                            TextField("Enter", text: $lbp)
                                .frame(width: 80.0)
                        }
                        HStack{
                            Text("Vessel Lenght (m): ")
                            TextField("Enter", text: $vesselLenght)
                                .frame(width: 80.0)
                            
                        }
                        HStack{
                            Text("Vessel Beam (m): ")
                            TextField("Enter", text: $vesselBeam)
                                .frame(width: 80.0)
                        }
                    }
                    Section{
                        
                        HStack{
                            Text("Charted Water depth (m): ")
                            TextField("Enter", text: $chartedWaterDepth)
                                .padding(.leading,0.0)
                                .frame(width: 80.0)
                        }
                        HStack{
                            Text("Sounding Datum Allowance (m): ")
                            TextField("Enter", text: $soundingDatumAllowance)
                                .frame(width: 80.0)
                        }
                        HStack{
                            Text("Tide Height (m): ")
                            TextField("Enter", text: $tideHeight)
                                .frame(width: 80.0)
                        }}
                    Section{
                        
                        HStack{
                            Text("Available Water Depths (m): \(availableWaterDepths, specifier: "%.2f") ")
                        }.foregroundColor(Color.red)
                        
                    }
                    Section{
                        HStack{
                            Text("Deepest static Draft (m): ")
                            TextField("Enter", text: $maxVesselDraft)
                                .frame(width: 80.0)
                        }
                        HStack{
                            Text("SW Density allowance (m): ")
                            TextField("Enter", text: $seaWaterDensityAllowance)
                                .frame(width: 80.0)
                        }
                        HStack{
                            Text("Rolling Allowance (deg): ")
                            TextField("Enter", text: $rollingDeg)
                                .frame(width: 50.0)
                            Text("(m) \(rollingError, specifier: "%.2f")")
                                .frame(width: 75.0)
                        }
                        HStack{
                            Text("Pitching Allowance (deg): ")
                            TextField("Enter", text: $pitchingDeg)
                                .frame(width: 50.0)
                            Text("(m) \(pitchingError, specifier: "%.2f")")
                                .frame(width: 74.0)
                        }
                        HStack{
                            Text("Other factors (m): ")
                            TextField("Enter", text: $otherFactors)
                                .frame(width: 80.0)
                        }
                    }

                    Section{
                        HStack{
                            Text( "Deepest dynamic draught (m): \(deepestDynamicDraft, specifier: "%.2f")" )
                        }.foregroundColor(Color.red)
                    }
                    Section{
                        VStack{
                            Text("Select CATZOC")
                            Picker(selection: $selectedCatzoc, label: Text("Select CATZOC")) {
                                ForEach(0..<catzoc.count) {element in Text(self.catzoc[element])
                                }
                            } .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    Section{
                        HStack{
                            Text( "Maximum Safe Speed (knts): \(mmaximumSafeSpeed, specifier: "%.2f")" )
                        }.foregroundColor(Color.blue)
                    }
                    Section{
                        HStack{
                            Text( "Squat (m): \(squat, specifier: "%.2f")" )
                        }
                    }
                    Section{
                        HStack{
                            Text( "UKC (m): \(ukc, specifier: "%.2f")" )
                        }.foregroundColor(Color.red)
                    }


                }
                .navigationBarTitle("Vessel Safe Speed / UKC Calculator", displayMode: .inline)
                
            }
            .padding(.top, -70.0)
        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
