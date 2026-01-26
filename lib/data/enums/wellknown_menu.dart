enum WellknownMenuId {
  pms,
  roomSetting,
  amenities,
  roomType,
  sortRoomType,
  bedType,
  room,
  sortRooms,
  statusColor,
  roomOwner,
  rateSetting,
  rateType,
  season,
  roomRates,
  tax,
  sortRates,
  houseKeepingSetting,
  houseKeepingUnit,
  houseKeepingStatus,
  houseKeepingRemarks,
  masterSetting,
  generalMasterSetting,
  currency,
  payMethod,
  extraCharge,
  discount,
  identityType,
  transportationMode,
  payOuts,
  reservationType,
  vipStatus,
  mealPlan,
  emailTemplates,
  templateCategory,
  template,
  guestPreferences,
  preferenceType,
  preferences,
  reasons,
  reason,
  blackListReason,
  marketing,
  marketCode,
  businessSource,
  reviews,
  others,
  holidays,
  generalSetting,
  property,
  hotelInformation,
  emailAccounts,
  taxAccountConfiguration,
  general,
  displaySettings,
  emailSettings,
  printSettings,
  checkInReservationSettings,
  paginationSettings,
  documentNumbering,
  formula,
  notices,
  settings,
  frontOffice,
  newReservation,
  previousReservation,
  guestDatabase,
  guestReview,
  nightAudit,
  groupReservationMenu,
  groupReservation,
  inhouse,
  departedGroup,
  cashiering,
  travelAgentDatabase,
  companyDatabase,
  expenseVoucher,
  chashieringCenter,
  changeExchangeRate,
  cityLedgerPayments,
  pos,
  houseKeeping,
  houseStatus,
  maintenanceBlockList,
  workOrderList,
  reports,
  userSetting,
  user,
  userLevel,
  cardType,
  reviewTypes,
  guestCategory,
  pmsFrontOffice,
  pmsConfiguration,
  unsettledFolioList,
  stopSales,
  lostAndFound,
  roomPosting,
  roomView,
  currencyExchange,
  taxManagement,
  cityLedger,
  salesPosting,
  integration,
  failedCMRequest,
}

extension WellknownMenuIdExt on WellknownMenuId {
  int get id {
    switch (this) {
      case WellknownMenuId.pms:
        return 276;
      case WellknownMenuId.roomSetting:
        return 277;
      case WellknownMenuId.amenities:
        return 278;
      case WellknownMenuId.roomType:
        return 279;
      case WellknownMenuId.sortRoomType:
        return 285;
      case WellknownMenuId.bedType:
        return 280;
      case WellknownMenuId.room:
        return 281;
      case WellknownMenuId.sortRooms:
        return 284;
      case WellknownMenuId.statusColor:
        return 282;
      case WellknownMenuId.roomOwner:
        return 283;
      case WellknownMenuId.rateSetting:
        return 286;
      case WellknownMenuId.rateType:
        return 287;
      case WellknownMenuId.season:
        return 288;
      case WellknownMenuId.roomRates:
        return 289;
      case WellknownMenuId.tax:
        return 290;
      case WellknownMenuId.sortRates:
        return 291;
      case WellknownMenuId.houseKeepingSetting:
        return 292;
      case WellknownMenuId.houseKeepingUnit:
        return 293;
      case WellknownMenuId.houseKeepingStatus:
        return 296;
      case WellknownMenuId.houseKeepingRemarks:
        return 297;
      case WellknownMenuId.masterSetting:
        return 298;
      case WellknownMenuId.generalMasterSetting:
        return 299;
      case WellknownMenuId.currency:
        return 300;
      case WellknownMenuId.payMethod:
        return 301;
      case WellknownMenuId.extraCharge:
        return 303;
      case WellknownMenuId.discount:
        return 304;
      case WellknownMenuId.identityType:
        return 305;
      case WellknownMenuId.transportationMode:
        return 306;
      case WellknownMenuId.payOuts:
        return 307;
      case WellknownMenuId.reservationType:
        return 308;
      case WellknownMenuId.vipStatus:
        return 309;
      case WellknownMenuId.mealPlan:
        return 379;
      case WellknownMenuId.emailTemplates:
        return 310;
      case WellknownMenuId.templateCategory:
        return 311;
      case WellknownMenuId.template:
        return 312;
      case WellknownMenuId.guestPreferences:
        return 313;
      case WellknownMenuId.preferenceType:
        return 314;
      case WellknownMenuId.preferences:
        return 315;
      case WellknownMenuId.reasons:
        return 316;
      case WellknownMenuId.reason:
        return 317;
      case WellknownMenuId.blackListReason:
        return 318;
      case WellknownMenuId.marketing:
        return 319;
      case WellknownMenuId.marketCode:
        return 320;
      case WellknownMenuId.businessSource:
        return 321;
      case WellknownMenuId.reviews:
        return 323;
      case WellknownMenuId.others:
        return 324;
      case WellknownMenuId.holidays:
        return 325;
      case WellknownMenuId.generalSetting:
        return 326;
      case WellknownMenuId.property:
        return 327;
      case WellknownMenuId.hotelInformation:
        return 328;
      case WellknownMenuId.emailAccounts:
        return 329;
      case WellknownMenuId.taxAccountConfiguration:
        return 330;
      case WellknownMenuId.general:
        return 331;
      case WellknownMenuId.displaySettings:
        return 332;
      case WellknownMenuId.emailSettings:
        return 333;
      case WellknownMenuId.printSettings:
        return 334;
      case WellknownMenuId.checkInReservationSettings:
        return 335;
      case WellknownMenuId.paginationSettings:
        return 336;
      case WellknownMenuId.documentNumbering:
        return 384;
      case WellknownMenuId.formula:
        return 337;
      case WellknownMenuId.notices:
        return 338;
      case WellknownMenuId.settings:
        return 341;
      case WellknownMenuId.frontOffice:
        return 352;
      case WellknownMenuId.newReservation:
        return 353;
      case WellknownMenuId.previousReservation:
        return 354;
      case WellknownMenuId.guestDatabase:
        return 355;
      case WellknownMenuId.guestReview:
        return 356;
      case WellknownMenuId.nightAudit:
        return 357;
      case WellknownMenuId.groupReservationMenu:
        return 358;
      case WellknownMenuId.groupReservation:
        return 359;
      case WellknownMenuId.inhouse:
        return 360;
      case WellknownMenuId.departedGroup:
        return 361;
      case WellknownMenuId.cashiering:
        return 362;
      case WellknownMenuId.travelAgentDatabase:
        return 363;
      case WellknownMenuId.companyDatabase:
        return 364;
      case WellknownMenuId.expenseVoucher:
        return 365;
      case WellknownMenuId.chashieringCenter:
        return 366;
      case WellknownMenuId.changeExchangeRate:
        return 367;
      case WellknownMenuId.cityLedgerPayments:
        return 368;
      case WellknownMenuId.pos:
        return 369;
      case WellknownMenuId.houseKeeping:
        return 370;
      case WellknownMenuId.houseStatus:
        return 371;
      case WellknownMenuId.maintenanceBlockList:
        return 372;
      case WellknownMenuId.workOrderList:
        return 373;
      case WellknownMenuId.reports:
        return 374;
      case WellknownMenuId.userSetting:
        return 375;
      case WellknownMenuId.user:
        return 377;
      case WellknownMenuId.userLevel:
        return 378;
      case WellknownMenuId.cardType:
        return 302;
      case WellknownMenuId.reviewTypes:
        return 380;
      case WellknownMenuId.guestCategory:
        return 381;
      case WellknownMenuId.pmsFrontOffice:
        return 382;
      case WellknownMenuId.pmsConfiguration:
        return 383;
      case WellknownMenuId.unsettledFolioList:
        return 385;
      case WellknownMenuId.stopSales:
        return 386;
      case WellknownMenuId.lostAndFound:
        return 391;
      case WellknownMenuId.roomPosting:
        return 392;
      case WellknownMenuId.roomView:
        return 390;
      case WellknownMenuId.currencyExchange:
        return 389;
      case WellknownMenuId.taxManagement:
        return 387;
      case WellknownMenuId.cityLedger:
        return 388;
      case WellknownMenuId.salesPosting:
        return 393;
      case WellknownMenuId.integration:
        return 394;
      case WellknownMenuId.failedCMRequest:
        return 395;
    }
  }
}
