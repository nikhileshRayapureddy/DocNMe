//
//  VCDoctorsEventCalendar.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 22/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
import Alamofire
import AlamofireObjectMapper
import RealmSwift


class VCDoctorsEventCalendar: UIViewController, OnAppointmentDelegateRescheduled {


    @IBOutlet weak var l_labelloading: UILabel!
    @IBOutlet weak var l_heading_monthyear: UILabel!
    @IBOutlet weak var tableview_appointment: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let formatter: DateFormatter = DateFormatter();
    var formatterMonthYear: DateFormatter?;
    let formatterTime: DateFormatter = DateFormatter();


    var arrOfAppointments = [AppointmentModel]();
    var doctor: DoctorModel?;
    var dictionaryAppointments = [String: [AppointmentModel]]();

    func onRescheduled() {
        self.refreshDataFromDB();
    }

    override func viewDidLoad() {
        super.viewDidLoad();
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.scrollToDate(Date());
        formatterTime.timeZone = Calendar.current.timeZone;
        formatterTime.locale = Calendar.current.locale;
        formatterTime.dateFormat = "hh:mm aa";
        
        formatterMonthYear = Utility.getDateFormatter(dateFormat: "MMMM yyyy");
        
        tableview_appointment.dataSource = self;
        tableview_appointment.delegate = self;
        
        print("on load");
        
        let doctorData = UserDefaults.standard.object(forKey: Names.DOCTOR_DATA)
        self.doctor = DoctorModel(JSONString: doctorData as! String)

        
        if self.doctor != nil {
            self.title = self.doctor?.name;
            self.apiGetAppointmentsForADoctor(doctor: doctor);
        }
        else
        {
            let alert = UIAlertController(title: "Alert!"
                , message: "Doctor Data not avaialable.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                action in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)

        }
        

        self.selectCurrentDate()
//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.selectCurrentDate), userInfo: nil, repeats: false)
    }
    func selectCurrentDate()
    {
        calendarView.selectDates([Date()])
    }
    @IBAction func onClickAddAppointment(_ sender: UIButton) {
        let vcAdd: VCAddAppointment = UIStoryboard(
                name: Names.STORYBOARD.ADD_APPOINTMENT, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_ADDAPPOINTMENT) as! VCAddAppointment;
        vcAdd.doctorId = self.doctor?.id;
        self.navigationController?.pushViewController(vcAdd, animated: true);
    }


    func apiGetAppointmentsForADoctor(doctor: DoctorModel?) {
        self.l_labelloading.isHidden = false;
        formatter.dateFormat = "ddMMyyyy";
        formatter.timeZone = Calendar.current.timeZone;
        formatter.locale = Calendar.current.locale;
        
        //        self.refreshDataFromDB();
        //
        //        if self.dictionaryAppointments.count > 0 {
        //            self.l_labelloading.isHidden = true;
        //        }
        //
        let date = Calendar.current.date(byAdding: Calendar.Component.month, value: (-1), to: Date());
        let datePost = Calendar.current.date(byAdding: Calendar.Component.month, value: (1), to: Date());
        
        let params = [Names.ACCESS_TOKEN: UserPrefUtil.getAccessToken(), "fromTime": date?.millisecondsSince1970, "toTime": datePost?.millisecondsSince1970] as [String: Any];
        
        let urlRequest = ApiServices.createGetRequest(urlStr:
            DAMUrls.urlDoctorsEvent(doctorId: (doctor?.id)!
        ), parameters: params);
        
        app_delegate.showLoader(message: "Loading Appointments...")
        AlamofireManager.Manager.request(urlRequest).responseArray {
            (response: DataResponse<[AppointmentModel]>) in
            DispatchQueue.main.async {
                self.l_labelloading.isHidden = true;
                if (response.error == nil)
                {
                    self.checkAndStoreToData(response.result.value!);
                }
                else
                {
                    app_delegate.removeloder()
                }
            }
        }
    }

    let realm = try? Realm();

    private func checkAndStoreToData(_ list: [AppointmentModel]) {

        do {
            
            let updatedAppointments = self.realm?.objects(AppointmentModel.self).filter("isUpdated = false")
            try realm?.write {
                realm?.delete(updatedAppointments!)
            }
            
            try realm?.write({
                for item in list {
                    let res = self.realm?.objects(AppointmentModel.self).filter("id = '\((item.id!))'").first;
                    if res == nil {
                        self.realm?.add(item);
                        let personInfo = self.realm?.objects(PersonInfoModel.self).filter("id = '\(item.patientId!)'");
                        if personInfo == nil {
                            self.realm?.add(item.patientInfo!);
                        }

                        let doctorInfo = self.realm?.objects(PersonInfoModel.self).filter("id = '\(item.doctorId!)'");
                        if doctorInfo == nil {
                            self.realm?.add(item.doctorInfo!);
                        }
                    }
                }
            });
        } catch {
            print(error);
        }
        self.refreshDataFromDB();
    }

    private func refreshDataFromDB() {
        var arrOfApp = [AppointmentModel]();
        let idStr = self.doctor?.id!;
        let results = self.realm?.objects(AppointmentModel.self).filter("doctorId = '\(idStr!)' AND isDeleted = false").sorted(byKeyPath: "appointmentFrom", ascending: false);
        if results != nil {
            for item in results! {
                let tempApp = AppointmentModel.fromAppointmentModel(item);
                let patRes = self.realm?.objects(PersonInfoModel.self).filter("id = '\(item.patientId!)'").first;
                if patRes != nil {
                    let persong = PersonInfoModel();
                    persong.setFields(patRes!);
                    tempApp.patientInfo = persong;
                }
                arrOfApp.append(tempApp);
            }
            self.dictionaryAppointments.removeAll();
            self.dictionaryAppointments = AppointmentModel.getAppointmentsListFromArray(data: arrOfApp);

            self.calendarView.reloadData()
            self.selectCurrentDate()
            app_delegate.removeloder()
        }
    }


}


extension VCDoctorsEventCalendar: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        formatter.dateFormat = "ddMMyyyy";
        formatter.timeZone = Calendar.current.timeZone;
        formatter.locale = Calendar.current.locale;

        let startDate = formatter.date(from: "01012016");
        let endDate = formatter.date(from: "01012020");
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters;
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier:
        Names.VContIdentifiers.CALENDAR_CELL, for: indexPath) as! JTCalendarCell;
        if cellState.isSelected {
            cell.v_background.isHidden = false;
        } else {
            cell.v_background.isHidden = true;
        }
        let dateStr = formatter.string(from: date);
//        print(dateStr);
        if (self.dictionaryAppointments[dateStr] != nil) {
            cell.v_appointmentdot.isHidden = false;
        } else {
            cell.v_appointmentdot.isHidden = true;
        }

        handleCellTextColor(cell, cellState);

        cell.l_date.text = cellState.text;
        return cell;
    }

    private func handleCellTextColor(_ validCell: JTCalendarCell, _ state: CellState) {

        if (state.isSelected) {
            validCell.l_date.textColor = UIColor.white;
        } else {
            if state.dateBelongsTo == .thisMonth {
                validCell.l_date.textColor = UIColor.black;
            } else {
                validCell.l_date.textColor = UIColor.lightGray;
            }
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {


        if let JTcell =  cell as? JTCalendarCell
        {
            JTcell.v_background.isHidden = false;
        }

        self.l_heading_monthyear.text = self.formatterMonthYear?.string(from: date);

        self.arrOfAppointments.removeAll();
        if let arrOf: [AppointmentModel] = dictionaryAppointments[formatter.string(from: date)] {
            self.arrOfAppointments.append(contentsOf: arrOf.reversed());
            if ((arrOfAppointments.count) > 0) {
                self.tableview_appointment.reloadData();
            }
            
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if cell != nil && (cell as! JTCalendarCell).v_background != nil {
            (cell as! JTCalendarCell).v_background.isHidden = true;
            (cell as! JTCalendarCell).l_date.textColor = .black
        }

    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first;
        self.l_heading_monthyear.text = formatterMonthYear?.string(from: (date?.date)!).uppercased();

//        print(visibleDates.monthDates);
    }
}

extension VCDoctorsEventCalendar: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfAppointments.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appoint = self.arrOfAppointments[indexPath.row];
        let docInfo = self.realm?.objects(DoctorModel.self).filter("id = '\(appoint.doctorId!)'").first;
        if (docInfo != nil) {
            let prInfo = PersonInfoModel.fromDocInfo(docInfo);
            appoint.doctorInfo = prInfo;
        }
        let cell = tableview_appointment.dequeueReusableCell(withIdentifier: Names.VContIdentifiers.APPOINTMENTS_CELL) as! CellAppointmentTableViewCell;
        cell.l_patientname.text = appoint.patientInfo.name;
        cell.l_purpose.text = appoint.purpose;
        cell.l_time.text = formatterTime.string(from: Date.init(milliseconds: appoint.appointmentFrom));
        if let gend: Int = appoint.patientInfo.gender as? Int {
            if gend == 1 {
                cell.l_gender.text = "Male";
            } else {
                cell.l_gender.text = "Female";
            }
        } else {
            cell.l_gender.text = "";
        }
        if appoint.edd > 0 && appoint.patientInfo.gender == 0 {
            print(appoint.edd);
            let curDate = Date();
//            let diff = (curDate.millisecondsSince1970 - appoint.edd);
            if let gestTime = Utility.calculateGestAge(appoint.edd) {
                cell.lGestAge.text = gestTime;
            }
            cell.lGestAge.isHidden = false;
        }else {
            cell.lGestAge.isHidden = true;
        }
        
        if appoint.patientInfo.gender == 1 {
            cell.iAvatar.image = #imageLiteral(resourceName: "user_avatar_male");
        }else {
            cell.iAvatar.image = #imageLiteral(resourceName: "user_avatar");
        }
        

        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview_appointment.deselectRow(at: indexPath, animated: false);
        
        
        var arrOfApp = [AppointmentModel]();
        let idStr = self.doctor?.id!;
        let results = self.realm?.objects(AppointmentModel.self).filter("doctorId = '\(idStr!)' AND isDeleted = false").sorted(byKeyPath: "appointmentFrom", ascending: false);
        if results != nil {
            for item in results! {
                let tempApp = AppointmentModel.fromAppointmentModel(item);
                let patRes = self.realm?.objects(PersonInfoModel.self).filter("id = '\(item.patientId!)'").first;
                if patRes != nil {
                    let persong = PersonInfoModel();
                    persong.setFields(patRes!);
                    tempApp.patientInfo = persong;
                }
                arrOfApp.append(tempApp);
            }
            self.dictionaryAppointments.removeAll();
            self.dictionaryAppointments = AppointmentModel.getAppointmentsListFromArray(data: arrOfApp);
            
            self.arrOfAppointments.removeAll();
            if let arrOf: [AppointmentModel] = dictionaryAppointments[formatter.string(from: calendarView.selectedDates[0])] {
                self.arrOfAppointments.append(contentsOf: arrOf.reversed());
                if ((arrOfAppointments.count) > 0) {
                    self.tableview_appointment.reloadData();
                }
                
            }
            calendarView.selectDates(calendarView.selectedDates)
        }

        let appointmentLocal = self.arrOfAppointments[indexPath.row];
        let alert = UIAlertController(title: appointmentLocal.patientInfo.name as? String
                , message: nil, preferredStyle: UIAlertControllerStyle.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Basic Details", style: UIAlertActionStyle.default, handler: {
            action in
            self.onClickBasicDetails(appointment: appointmentLocal);
        }))
        alert.addAction(UIAlertAction(title: "Reschedule Appointment", style: UIAlertActionStyle.default, handler: {
            action in
            self.onClickRescheduleAppointment(appointmentLocal: appointmentLocal);

        }))

        alert.addAction(UIAlertAction(title: "Cancel Appointment", style: UIAlertActionStyle.destructive, handler: {
            action in
            self.onClickCancelAppointment(appointment: appointmentLocal, indexPath: indexPath.row);
        }))

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))


        // show the alert
        self.present(alert, animated: true, completion: nil)

    }

    func onClickRescheduleAppointment(appointmentLocal: AppointmentModel) {

        let vcReschedule: VCRescheduleAppointment = self.storyboard!.instantiateViewController(withIdentifier: Names.VContIdentifiers.RESCHEDULE_APPOINTMENT) as! VCRescheduleAppointment;
        vcReschedule.appointment = appointmentLocal;
        vcReschedule.appointmentDelegate = self;
        self.navigationController?.pushViewController(vcReschedule, animated: true);
    }

    func onClickBasicDetails(appointment: AppointmentModel) {
        let vcPatientInfo: PatientInfoPagerViewController = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.PATIENTINFO_PAGERVIEWCONTROLLER) as! PatientInfoPagerViewController;
        let personInfo = PersonInfoModel();
        personInfo.setFields(appointment.patientInfo);
        vcPatientInfo.patientInfo = personInfo;
        self.navigationController?.pushViewController(vcPatientInfo, animated: true);
    }

    func onClickCancelAppointment(appointment: AppointmentModel, indexPath: Int) {
        let alert = UIAlertController(title: appointment.patientInfo.name
                , message: nil, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Confirm Cancellation", style: UIAlertActionStyle.destructive, handler: {
            action in
            self.onConfirmCancelAppointment(appointment: appointment, index: indexPath);
        }))

        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))


        // show the alert
        self.present(alert, animated: true, completion: nil)

    }


    func onConfirmCancelAppointment(appointment: AppointmentModel, index: Int) {

        if let results = self.realm?.objects(AppointmentModel.self).filter("id ='\(appointment.id!)' ").first
        {
            try? realm?.write({
                self.realm?.delete(results);
                self.apiGetAppointmentsForADoctor(doctor: doctor);
                if arrOfAppointments.count > index {
                    self.arrOfAppointments.remove(at: index)
                }
                self.tableview_appointment.reloadData();
            })
            
            
            print("Confirmed");
            var dict = [String: Any]();
            dict[Names.APPOINTMENTFROM] = appointment.appointmentFrom;
            dict[Names.APPOINTMENTTO] = appointment.appointmentTo;
            dict[Names.DOCTORPERSONID] = appointment.doctorInfo.id;
            dict[Names.ID] = appointment.id;
            dict[Names.PATIENTPERSONID] = appointment.patientInfo.id
            dict[Names.PURPOSE] = appointment.purpose;
            dict[Names.STATUS] = Names.StatusAppointment.CANCEL;
            
            let request = ApiServices.createPostRequest(urlStr: DAMUrls.urlCancelAppointment(), parameters: dict);
            AlamofireManager.Manager.request(request).responseData {
                response in
                print("Data aa gya : Request Appointment Cancellation");
                //            self.navigationController?.popViewController(animated: true);
                self.apiGetAppointmentsForADoctor(doctor: self.doctor);
            }
            
        }
    }
}
