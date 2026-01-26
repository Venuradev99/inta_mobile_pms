enum WellknownReservationSetting {
  twentyFourHoursCheckOut, // 1
  autoPostEarlyCheckIn,     // 4
  earlyCheckInGracePeriod,  // 5
  earlyCheckInCharge,       // 6
  autoPostForLateCheckOut,  // 7
  lateCheckOutGracePeriod,  // 8
  lateCheckoutCharge,       // 9
  postCancellationFee,      // 10
  percentageOf,             // 11
  withInNightRoomCharges,   // 14
  postNoShowFee,            // 16
  fixedAmount,              // 17
  fromDate,                 // 20
  toDate,                   // 21
  allowExtraChildRateBasedOnChildAge,   // 22
  defaultMaximumAgeInNoCostCategory,    // 23
  maximumChildAge,                       // 24
  allowExtraChildRateBasedOnChildOccupancy, // 25
  emailReservationVoucher,               // 26
  sendReservationVoucherAsPDF,           // 27
  setOccupiedRoomsDirty,                 // 28
  setRoomAsDirty,                        // 29
  setSourceRoomAsDirty,                  // 30
  overbookingEnable,                     // 31
  baseOccupancyDefault,                  // 32
  stayViewOpen,                          // 33
  holdReleaseGuarantee,                  // 35
  frontRateMode,                         // 36
  sendReviewEmailLinkTo,                 // 37
  forReservationModeSetRoomSelectionCompulsory, // 38
}

extension WellknownReservationSettingExt on WellknownReservationSetting {
  int get id {
    switch (this) {
      case WellknownReservationSetting.twentyFourHoursCheckOut:
        return 1;
      case WellknownReservationSetting.autoPostEarlyCheckIn:
        return 4;
      case WellknownReservationSetting.earlyCheckInGracePeriod:
        return 5;
      case WellknownReservationSetting.earlyCheckInCharge:
        return 6;
      case WellknownReservationSetting.autoPostForLateCheckOut:
        return 7;
      case WellknownReservationSetting.lateCheckOutGracePeriod:
        return 8;
      case WellknownReservationSetting.lateCheckoutCharge:
        return 9;
      case WellknownReservationSetting.postCancellationFee:
        return 10;
      case WellknownReservationSetting.percentageOf:
        return 11;
      case WellknownReservationSetting.withInNightRoomCharges:
        return 14;
      case WellknownReservationSetting.postNoShowFee:
        return 16;
      case WellknownReservationSetting.fixedAmount:
        return 17;
      case WellknownReservationSetting.fromDate:
        return 20;
      case WellknownReservationSetting.toDate:
        return 21;
      case WellknownReservationSetting.allowExtraChildRateBasedOnChildAge:
        return 22;
      case WellknownReservationSetting.defaultMaximumAgeInNoCostCategory:
        return 23;
      case WellknownReservationSetting.maximumChildAge:
        return 24;
      case WellknownReservationSetting.allowExtraChildRateBasedOnChildOccupancy:
        return 25;
      case WellknownReservationSetting.emailReservationVoucher:
        return 26;
      case WellknownReservationSetting.sendReservationVoucherAsPDF:
        return 27;
      case WellknownReservationSetting.setOccupiedRoomsDirty:
        return 28;
      case WellknownReservationSetting.setRoomAsDirty:
        return 29;
      case WellknownReservationSetting.setSourceRoomAsDirty:
        return 30;
      case WellknownReservationSetting.overbookingEnable:
        return 31;
      case WellknownReservationSetting.baseOccupancyDefault:
        return 32;
      case WellknownReservationSetting.stayViewOpen:
        return 33;
      case WellknownReservationSetting.holdReleaseGuarantee:
        return 35;
      case WellknownReservationSetting.frontRateMode:
        return 36;
      case WellknownReservationSetting.sendReviewEmailLinkTo:
        return 37;
      case WellknownReservationSetting.forReservationModeSetRoomSelectionCompulsory:
        return 38;
    }
  }
}
