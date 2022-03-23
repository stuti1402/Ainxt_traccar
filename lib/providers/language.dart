import 'package:flutter/material.dart';

class Language extends ChangeNotifier {
  String? _lang = 'EN'; //language;

  getLanguage() {
    return _lang;
  }

  setLanguage(String lang) {
    _lang = lang;
    notifyListeners();
  }

  ///User Profile translated Strings
  String tSettings() {
    if (getLanguage() == 'AR') {
      return "الإعدادات";
    } else if (getLanguage() == 'EN') {
      return "Settings";
    } else {
      return "Parametres";
    }
  }

  String tAccount() {
    if (getLanguage() == 'AR') {
      return "حساب";
    } else if (getLanguage() == 'EN') {
      return "Account";
    } else {
      return "Compte";
    }
  }

  String tGeoNotif() {
    if (getLanguage() == 'AR') {
      return "دخول/خروج السياج الجغرافي";
    } else if (getLanguage() == 'EN') {
      return "Geo-fence enter/exit";
    } else {
      return "Geo-fence entrer/sortie";
    }
  }

  String tConsumNotif() {
    if (getLanguage() == 'AR') {
      return "استهلاك الوقود";
    } else if (getLanguage() == 'EN') {
      return "Fuel Consumption";
    } else {
      return "Consommation de Carburant";
    }
  }

  String tFuel() {
    if (getLanguage() == 'AR') {
      return "الوقود";
    } else if (getLanguage() == 'EN') {
      return "Fuel ";
    } else {
      return "Carburant";
    }
  }

  String tDeviceTemp() {
    if (getLanguage() == 'AR') {
      return "درجة الحرارة";
    } else if (getLanguage() == 'EN') {
      return "Temperature ";
    } else {
      return "Temperature";
    }
  }

  String tDeleting() {
    if (getLanguage() == 'AR') {
      return "الحذف";
    } else if (getLanguage() == 'EN') {
      return "Deleting ";
    } else {
      return "suppression";
    }
  }

  String tDelete() {
    if (getLanguage() == 'AR') {
      return "حذف";
    } else if (getLanguage() == 'EN') {
      return "Delete";
    } else {
      return "Effacer";
    }
  }

  String tLastVidange() {
    if (getLanguage() == 'AR') {
      return "تغيير الزيت الأخير";
    } else if (getLanguage() == 'EN') {
      return "Number of times Maintained";
    } else {
      return "Dernière-Vidange";
    }
  }

  String tNextVidange() {
    if (getLanguage() == 'AR') {
      return "تغيير الزيت القادم";
    } else if (getLanguage() == 'EN') {
      return "Next-Oil-Change";
    } else {
      return "Prochain-Vidange";
    }
  }

  String tPeriod() {
    if (getLanguage() == 'AR') {
      return "المدة ";
    } else if (getLanguage() == 'EN') {
      return "Period";
    } else {
      return "Période";
    }
  }

  String tNextMaintenanceDateTime() {
    if (getLanguage() == 'AR') {
      return "الموعد القادم";
    } else if (getLanguage() == 'EN') {
      return "Next-Date";
    } else {
      return "Prochain rendez-vous";
    }
  }

  String tOkay() {
    if (getLanguage() == 'AR') {
      return "تمام ";
    } else if (getLanguage() == 'EN') {
      return "Okay";
    } else {
      return "D'accord";
    }
  }

  String tUpdate() {
    if (getLanguage() == 'AR') {
      return "تحديث";
    } else if (getLanguage() == 'EN') {
      return "Update";
    } else {
      return "Mettre à jour";
    }
  }

  String tAdd() {
    if (getLanguage() == 'AR') {
      return "إضافة";
    } else if (getLanguage() == 'EN') {
      return "Add";
    } else {
      return "Ajout";
    }
  }

  String tDeletingConfirmMsg() {
    if (getLanguage() == 'AR') {
      return "هل انت متأكد من الحذف؟";
    } else if (getLanguage() == 'EN') {
      return "Are you sure you want to delete? ";
    } else {
      return "Êtes-vous sûr de vouloir supprimer?";
    }
  }

  String tSpeedLimitNotif() {
    if (getLanguage() == 'AR') {
      return "الحد الأقصى للسرعة";
    } else if (getLanguage() == 'EN') {
      return "Speed Limit";
    } else {
      return "Limitation de vitesse";
    }
  }

  String tLogOut() {
    if (getLanguage() == 'AR') {
      return "تسجيل خروج";
    } else if (getLanguage() == 'EN') {
      return "SIGN OUT";
    } else {
      return "DECONNEXION";
    }
  }

  String tLogIn() {
    if (getLanguage() == 'AR') {
      return "تسجيل الدخول";
    } else if (getLanguage() == 'EN') {
      return "SIGN IN";
    } else {
      return "CONNEXION";
    }
  }

  String tNoInternetConnection() {
    if (getLanguage() == 'AR') {
      return "لا يوجد اتصال بالإنترنت";
    } else if (getLanguage() == 'EN') {
      return "No Internet Connection";
    } else {
      return "Pas de Connexion Internet";
    }
  }

  String tNoInternetConnectionMsg() {
    if (getLanguage() == 'AR') {
      return "أنت غير متصل بالإنترنت. تأكد من تشغيل wifi أو بيانات الهاتف المحمول ، ووضع الطائرة في وضع الإيقاف";
    } else if (getLanguage() == 'EN') {
      return "you are not connected to the internet. Make sure your wifi or mobile data is On,Airplane mode is off";
    } else {
      return "vous n'êtes pas connecté à Internet. Assurez-vous que votre wifi ou vos données mobiles sont activés, le mode avion est désactivé";
    }
  }

  String tEmail() {
    if (getLanguage() == 'AR') {
      return " البريد الإلكتروني / اسم المستخدم ";
    } else if (getLanguage() == 'EN') {
      return "Email/Username";
    } else {
      return "e-mail/nom d'utilisateur";
    }
  }

  String tPassword() {
    if (getLanguage() == 'AR') {
      return "كلمه السر";
    } else if (getLanguage() == 'EN') {
      return "Password";
    } else {
      return "mot de passe";
    }
  }

  String tRequired() {
    if (getLanguage() == 'AR') {
      return "* مطلوب";
    } else if (getLanguage() == 'EN') {
      return "* required";
    } else {
      return "* obligatoire";
    }
  }

  String tConfirmEmail() {
    if (getLanguage() == 'AR') {
      return "أدخل بريدًا إلكترونيًا صالحًا";
    } else if (getLanguage() == 'EN') {
      return "Enter a valid e-mail";
    } else {
      return "Entrer une adresse email valide";
    }
  }

  String tConfirmPassword() {
    if (getLanguage() == 'AR') {
      return "أدخل كلمة مرور آمنة";
    } else if (getLanguage() == 'EN') {
      return "Enter a secure password";
    } else {
      return "Entrez un mot de passe sécurisé";
    }
  }

  String tConfirm() {
    if (getLanguage() == 'AR') {
      return "تأكيد";
    } else if (getLanguage() == 'EN') {
      return "Confirm";
    } else {
      return "Confirmer";
    }
  }

  String tCancel() {
    if (getLanguage() == 'AR') {
      return "إلغاء";
    } else if (getLanguage() == 'EN') {
      return "Cancel";
    } else {
      return "Cancel";
    }
  }

  String tLanguage() {
    if (getLanguage() == 'AR') {
      return "اللغة";
    } else if (getLanguage() == 'EN') {
      return "Language";
    } else {
      return "Langue";
    }
  }

  String tAlerte() {
    if (getLanguage() == 'AR') {
      return "تنبيهات";
    } else if (getLanguage() == 'EN') {
      return "Alerts";
    } else {
      return "Alertes";
    }
  }

  String tNotification() {
    if (getLanguage() == 'AR') {
      return "إشعارات";
    } else if (getLanguage() == 'EN') {
      return "Notifications";
    } else {
      return "Notifications";
    }
  }

  String tMaintenancePaper() {
    if (getLanguage() == 'AR') {
      return "أوراق السيارة";
    } else if (getLanguage() == 'EN') {
      return "Device Details";
    } else {
      return "Papiers de vehicule";
    }
  }

  String tMaintenanceMaintenance() {
    if (getLanguage() == 'AR') {
      return "اعمال صيانة ";
    } else if (getLanguage() == 'EN') {
      return "Maintenance ";
    } else {
      return "Maintenance ";
    }
  }

  String tMaintenance() {
    if (getLanguage() == 'AR') {
      return "اعمال صيانة ";
    } else if (getLanguage() == 'EN') {
      return "Maintenances ";
    } else {
      return "Entretiens ";
    }
  }

  String tDrivers() {
    if (getLanguage() == 'AR') {
      return "راكب السيارة";
    } else if (getLanguage() == 'EN') {
      return "Drivers";
    } else {
      return "Conducteurs";
    }
  }

  String tDevicesLoading() {
    if (getLanguage() == 'AR') {
      return "انتظر حتى يتم تحميل أجهزة المركبات";
    } else if (getLanguage() == 'EN') {
      return "Wait for the devices to load";
    } else {
      return "attendre que les appareils des véhicules soient chargés";
    }
  }

  String tLoading() {
    if (getLanguage() == 'AR') {
      return "... جار التحميل";
    } else if (getLanguage() == 'EN') {
      return "loading ...";
    } else {
      return "Chargement en cours ...";
    }
  }

  String tLoadingMoreTime() {
    if (getLanguage() == 'AR') {
      return "قد تستغرق هذه العملية وقتًا طويلاً";
    } else if (getLanguage() == 'EN') {
      return "this operation may take a long time ";
    } else {
      return "cette opération peut prendre beaucoup de temps";
    }
  }

  String tLoaded() {
    if (getLanguage() == 'AR') {
      return " التحميل";
    } else if (getLanguage() == 'EN') {
      return "loaded";
    } else {
      return "Chargés.";
    }
  }

  String tDownloadPdf() {
    if (getLanguage() == 'AR') {
      return "تحميل PDF";
    } else if (getLanguage() == 'EN') {
      return "Download pdf";
    } else {
      return "Télécharger le PDF";
    }
  }

  String tDriver() {
    if (getLanguage() == 'AR') {
      return "راكب السيارة";
    } else if (getLanguage() == 'EN') {
      return "Driver";
    } else {
      return "Conducteur";
    }
  }

  String tInvalidCredentials() {
    if (getLanguage() == 'AR') {
      return "بيانات الاعتماد غير صالحة";
    } else if (getLanguage() == 'EN') {
      return "Invalid Credentials";
    } else {
      return "Les informations d'identification invalides";
    }
  }

  String tNoAdminAccess() {
    if (getLanguage() == 'AR') {
      return "تسجيل الدخول محظور على المشرف";
    } else if (getLanguage() == 'EN') {
      return "login prohibited for admin";
    } else {
      return "login interdit pour admin";
    }
  }

  String tGraphic() {
    if (getLanguage() == 'AR') {
      return "الجرافيك";
    } else if (getLanguage() == 'EN') {
      return "Graphic";
    } else {
      return "Graphique";
    }
  }

  String tReport() {
    if (getLanguage() == 'AR') {
      return "تقرير القيادة";
    } else if (getLanguage() == 'EN') {
      return "Driving Report";
    } else {
      return "Rapport Conduite";
    }
  }

  String tDevices() {
    if (getLanguage() == 'AR') {
      return "مركبات";
    } else if (getLanguage() == 'EN') {
      return "Devices";
    } else {
      return "Vehicules";
    }
  }

  String tTodayTrip() {
    if (getLanguage() == 'AR') {
      return "رحلة اليوم";
    } else if (getLanguage() == 'EN') {
      return "Today's Trip";
    } else {
      return "Parcours d'aujourd'hui";
    }
  }

  String tOnline() {
    if (getLanguage() == 'AR') {
      return "متصل";
    } else if (getLanguage() == 'EN') {
      return "Online";
    } else {
      return "En ligne";
    }
  }

  String tOffline() {
    if (getLanguage() == 'AR') {
      return "غير متصل";
    } else if (getLanguage() == 'EN') {
      return "Offline";
    } else {
      return "Hors ligne";
    }
  }

  String tStopped() {
    if (getLanguage() == 'AR') {
      return "توقفت";
    } else if (getLanguage() == 'EN') {
      return "Stopped";
    } else {
      return "Arrêté";
    }
  }

  String tMoving() {
    if (getLanguage() == 'AR') {
      return "في حركة";
    } else if (getLanguage() == 'EN') {
      return "Moving";
    } else {
      return "En mvt";
    }
  }

  String tDeviceName() {
    if (getLanguage() == 'AR') {
      return "اسم المركبة";
    } else if (getLanguage() == 'EN') {
      return "Vehicle Name";
    } else {
      return "Nom de vehicle";
    }
  }

  String tMaintenanceName() {
    if (getLanguage() == 'AR') {
      return "اسم الصيانة";
    } else if (getLanguage() == 'EN') {
      return "Maintenance Name";
    } else {
      return "Nom de Maintenance";
    }
  }

  String tPhone() {
    if (getLanguage() == 'AR') {
      return "رقم الهاتف";
    } else if (getLanguage() == 'EN') {
      return "Phone";
    } else {
      return "Téléphone";
    }
  }

  String tMovment() {
    if (getLanguage() == 'AR') {
      return "الحركة";
    } else if (getLanguage() == 'EN') {
      return "Movement";
    } else {
      return "Mouvement";
    }
  }

  String tParcours() {
    if (getLanguage() == 'AR') {
      return "رحلة السيارة";
    } else if (getLanguage() == 'EN') {
      return "History";
    } else {
      return "Voyage";
    }
  }

  String tStatus() {
    if (getLanguage() == 'AR') {
      return "الحالة";
    } else if (getLanguage() == 'EN') {
      return "Status";
    } else {
      return "Statut";
    }
  }

  String tSuivi() {
    if (getLanguage() == 'AR') {
      return "تعقب";
    } else if (getLanguage() == 'EN') {
      return "Tracking";
    } else {
      return "Suivi";
    }
  }

  String tDetails() {
    if (getLanguage() == 'AR') {
      return "تفاصيل";
    } else if (getLanguage() == 'EN') {
      return "Details ";
    } else {
      return "Details";
    }
  }

  String tAdress() {
    if (getLanguage() == 'AR') {
      return "العنوان";
    } else if (getLanguage() == 'EN') {
      return "Address ";
    } else {
      return "Adresse";
    }
  }

  String tLat() {
    if (getLanguage() == 'AR') {
      return "خط العرض";
    } else if (getLanguage() == 'EN') {
      return "Latitude ";
    } else {
      return "Latitude";
    }
  }

  String tAlt() {
    if (getLanguage() == 'AR') {
      return "الإرتفاع العمودي";
    } else if (getLanguage() == 'EN') {
      return "Altitude ";
    } else {
      return "Altitude";
    }
  }

  String tGpsProtocol() {
    if (getLanguage() == 'AR') {
      return "نوع نظام تحديد المواقع";
    } else if (getLanguage() == 'EN') {
      return "equipment type ";
    } else {
      return "type de l'équipement";
    }
  }

  String tLng() {
    if (getLanguage() == 'AR') {
      return "خط الطول";
    } else if (getLanguage() == 'EN') {
      return "Longitude ";
    } else {
      return "Longitude";
    }
  }

  String tSpeed() {
    if (getLanguage() == 'AR') {
      return "السرعة";
    } else if (getLanguage() == 'EN') {
      return "Speed ";
    } else {
      return "Vitesse";
    }
  }

  String tLastUpdate() {
    if (getLanguage() == 'AR') {
      return "اخر تحديث";
    } else if (getLanguage() == 'EN') {
      return "Last update ";
    } else {
      return "Dernière mise à jour";
    }
  }

  String tTotalDistance() {
    if (getLanguage() == 'AR') {
      return "المسافة الكلية";
    } else if (getLanguage() == 'EN') {
      return "Total Distance ";
    } else {
      return "Distance totale";
    }
  }

  String tDistance() {
    if (getLanguage() == 'AR') {
      return "المسافة";
    } else if (getLanguage() == 'EN') {
      return "Distance:";
    } else {
      return "Distance:";
    }
  }

  String tSat() {
    if (getLanguage() == 'AR') {
      return "الأقمار الصناعية";
    } else if (getLanguage() == 'EN') {
      return "Sat";
    } else {
      return "Sat";
    }
  }

  String tconsom() {
    if (getLanguage() == 'AR') {
      return "استهلاك";
    } else if (getLanguage() == 'EN') {
      return "Consumption";
    } else {
      return "Consommation";
    }
  }

  String tDays() {
    if (getLanguage() == 'AR') {
      return "يوم";
    } else if (getLanguage() == 'EN') {
      return "day";
    } else {
      return "jr";
    }
  }

  String tKm() {
    if (getLanguage() == 'AR') {
      return "كم ";
    } else if (getLanguage() == 'EN') {
      return " Km";
    } else {
      return " Km";
    }
  }

  String tAction() {
    if (getLanguage() == 'AR') {
      return "إجراءات ";
    } else if (getLanguage() == 'EN') {
      return " Actions";
    } else {
      return " Actions";
    }
  }

  String tKmh() {
    if (getLanguage() == 'AR') {
      return "كم/س ";
    } else if (getLanguage() == 'EN') {
      return " Km/h";
    } else {
      return " Km/h";
    }
  }

  String tMinutes() {
    if (getLanguage() == 'AR') {
      return "دق";
    } else if (getLanguage() == 'EN') {
      return "min";
    } else {
      return "min";
    }
  }

  String tHours() {
    if (getLanguage() == 'AR') {
      return "س ";
    } else if (getLanguage() == 'EN') {
      return " hr";
    } else {
      return " hr";
    }
  }

  String tCraneHours() {
    if (getLanguage() == 'AR') {
      return "ساعات العمل";
    } else if (getLanguage() == 'EN') {
      return "Working Hours";
    } else {
      return "Heures de Travail";
    }
  }

  String tLitre() {
    if (getLanguage() == 'AR') {
      return "لتر";
    } else if (getLanguage() == 'EN') {
      return " l";
    } else {
      return " l";
    }
  }

  String tNextStop() {
    if (getLanguage() == 'AR') {
      return "اضغط على الزر التالي للاختيار ";
    } else if (getLanguage() == 'EN') {
      return "press next button to select ";
    } else {
      return "appuyez sur le bouton suivant pour sélectionner";
    }
  }

  String tNoStop() {
    if (getLanguage() == 'AR') {
      return " لم يتم العثور على توقف";
    } else if (getLanguage() == 'EN') {
      return "no stops found ";
    } else {
      return "aucune arrêt trouvé";
    }
  }

  String tNoDetails() {
    if (getLanguage() == 'AR') {
      return "بدون تفاصيل";
    } else if (getLanguage() == 'EN') {
      return "no details ";
    } else {
      return "pas de détails";
    }
  }

  String tNoTodayTrip() {
    if (getLanguage() == 'AR') {
      return " لم يتم العثور على رحلة اليوم";
    } else if (getLanguage() == 'EN') {
      return "no trip found ";
    } else {
      return "aucune voyage trouvé";
    }
  }

  String tNoSelectedDevice() {
    if (getLanguage() == 'AR') {
      return " !! لم يتم اختيار مركبة";
    } else if (getLanguage() == 'EN') {
      return "No device selected!";
    } else {
      return "aucune vehicule selectionnée !!";
    }
  }

  String tHomeSelectDevice() {
    if (getLanguage() == 'AR') {
      return " لتحديد السيارة ، ارجع إلى الشاشة الرئيسية  ";
    } else if (getLanguage() == 'EN') {
      return "  To select a device, go back to map screen.";
    } else {
      return "pour sélectionner une véhicule, revenir à l'écran d'accueil";
    }
  }

  String tHomePage() {
    if (getLanguage() == 'AR') {
      return "الصفحة الرئيسية ";
    } else if (getLanguage() == 'EN') {
      return "Go Home ";
    } else {
      return "Page d'Accueil";
    }
  }

  String tGeneralReport() {
    if (getLanguage() == 'AR') {
      return "تقرير عام ";
    } else if (getLanguage() == 'EN') {
      return "Report ";
    } else {
      return "Rapport";
    }
  }

  String tMaxSpeed() {
    if (getLanguage() == 'AR') {
      return "السرعة القصوى";
    } else if (getLanguage() == 'EN') {
      return "Max-Speed";
    } else {
      return "Vitesse-Max";
    }
  }

  String tAverageSpeed() {
    if (getLanguage() == 'AR') {
      return "متوسط السرعة";
    } else if (getLanguage() == 'EN') {
      return "Average-Speed";
    } else {
      return "Vitesse-Moy";
    }
  }

  String tDeviceDetails() {
    if (getLanguage() == 'AR') {
      return " تفاصيل السيارة ";
    } else if (getLanguage() == 'EN') {
      return "Vehicle détails ";
    } else {
      return "Les détails du véhicule";
    }
  }

  String tExplore() {
    if (getLanguage() == 'AR') {
      return " استكشف ";
    } else if (getLanguage() == 'EN') {
      return "Explore ";
    } else {
      return "Explorer";
    }
  }

  String tEngineHours() {
    if (getLanguage() == 'AR') {
      return "ساعات عمل المحرك";
    } else if (getLanguage() == 'EN') {
      return "Engine-Hours ";
    } else {
      return "Heures-Moteur";
    }
  }

  String tSearch() {
    if (getLanguage() == 'AR') {
      return "بحث";
    } else if (getLanguage() == 'EN') {
      return "Search";
    } else {
      return "Chercher";
    }
  }

  String tStartTime() {
    if (getLanguage() == 'AR') {
      return "وقت البدء";
    } else if (getLanguage() == 'EN') {
      return "Start-time";
    } else {
      return "Heure-Debut";
    }
  }

  String tNotifTime() {
    if (getLanguage() == 'AR') {
      return " وقت التنبيه";
    } else if (getLanguage() == 'EN') {
      return "Notification Time";
    } else {
      return "Heure de Notification";
    }
  }

  String tTime() {
    if (getLanguage() == 'AR') {
      return "وقت ";
    } else if (getLanguage() == 'EN') {
      return "Time";
    } else {
      return "Heure";
    }
  }

  String tStops() {
    if (getLanguage() == 'AR') {
      return " محطات ";
    } else if (getLanguage() == 'EN') {
      return " Stops ";
    } else {
      return " Arrets ";
    }
  }

  String tStopNum() {
    if (getLanguage() == 'AR') {
      return " محطة عدد ";
    } else if (getLanguage() == 'EN') {
      return " Stops N° ";
    } else {
      return " Arret N° ";
    }
  }

  String tEndTime() {
    if (getLanguage() == 'AR') {
      return "وقت النهاية";
    } else if (getLanguage() == 'EN') {
      return "End-Time";
    } else {
      return "Heure-Fin";
    }
  }

  String tDuration() {
    if (getLanguage() == 'AR') {
      return "المدة الزمنية";
    } else if (getLanguage() == 'EN') {
      return "Duration";
    } else {
      return "Durée";
    }
  }

  String tFuelSpent() {
    if (getLanguage() == 'AR') {
      return "الوقود المستنفد";
    } else if (getLanguage() == 'EN') {
      return "Spent-Fuel";
    } else {
      return "Carburant-Dépensé";
    }
  }

  String tHome() {
    if (getLanguage() == 'AR') {
      return "الصفحة الرئيسية";
    } else if (getLanguage() == 'EN') {
      return "Home ";
    } else {
      return "Accueil";
    }
  }

  String tReplay() {
    if (getLanguage() == 'AR') {
      return "إعادة";
    } else if (getLanguage() == 'EN') {
      return "Replay";
    } else {
      return "Rejouer";
    }
  }

  String tMaps() {
    if (getLanguage() == 'AR') {
      return "خريطة جوجل";
    } else if (getLanguage() == 'EN') {
      return "Google Maps";
    } else {
      return "Google Maps";
    }
  }

  String tRememberme() {
    if (getLanguage() == 'AR') {
      return "تذكرنى";
    } else if (getLanguage() == 'EN') {
      return "Remember Me";
    } else {
      return "Souviens-toi de moi";
    }
  }

  String tChangeLanguage() {
    if (getLanguage() == 'AR') {
      return "تبديل اللغة";
    } else if (getLanguage() == 'EN') {
      return "Change Language";
    } else {
      return "Choisi une langue";
    }
  }

  String tChooseDevice() {
    if (getLanguage() == 'AR') {
      return "اختر مركبة";
    } else if (getLanguage() == 'EN') {
      return "Select a device";
    } else {
      return "Sélectionner une vehicule";
    }
  }

  String tChooseMaintenanceType() {
    if (getLanguage() == 'AR') {
      return "حدد نوع الصيانة";
    } else if (getLanguage() == 'EN') {
      return "Select a maintenance type";
    } else {
      return "Sélectionner une type de maintenance";
    }
  }

  String tChangePassword() {
    if (getLanguage() == 'AR') {
      return "تغيير كلمة المرور";
    } else if (getLanguage() == 'EN') {
      return "Change Password";
    } else {
      return "Changer le mot de passe";
    }
  }

  String tReceiveNotifications() {
    if (getLanguage() == 'AR') {
      return "الإشعارات";
    } else if (getLanguage() == 'EN') {
      return "Notifications";
    } else {
      return "Notifications";
    }
  }

  String tNoNotif() {
    if (getLanguage() == 'AR') {
      return "لا يوجد تنبيه اليوم";
    } else if (getLanguage() == 'EN') {
      return "no alert today";
    } else {
      return "aucune alerte aujourd'hui";
    }
  }

  String tNoMaintenanceOrPaper() {
    if (getLanguage() == 'AR') {
      return "لا يوجد صيانة أو زيارة فنية";
    } else if (getLanguage() == 'EN') {
      return "No maintenance or technical visit";
    } else {
      return "aucune maintenance ou visite technique";
    }
  }

  ///////////notifications///////////
  ///
  String tAllEvents() {
    if (getLanguage() == 'AR') {
      return "كل الأحداث";
    } else if (getLanguage() == 'EN') {
      return " All Events";
    } else {
      return "Tous les évènements";
    }
  }

  String tAllDevices() {
    if (getLanguage() == 'AR') {
      return "جميع المركبات ";
    } else if (getLanguage() == 'EN') {
      return " All Devices";
    } else {
      return "Tous les Vehicules";
    }
  }

  String tDeviceOnline() {
    if (getLanguage() == 'AR') {
      return "الجهاز متصل";
    } else if (getLanguage() == 'EN') {
      return "Device Online";
    } else {
      return "Appareil en ligne";
    }
  }

  String tDeviceOffline() {
    if (getLanguage() == 'AR') {
      return "الجهاز غير متصل";
    } else if (getLanguage() == 'EN') {
      return "Device Offline";
    } else {
      return "Appareil hors ligne";
    }
  }

  String tDeviceUnknown() {
    if (getLanguage() == 'AR') {
      return "جهاز غير معروف";
    } else if (getLanguage() == 'EN') {
      return "Device Offline";
    } else {
      return "Appareil inconnu";
    }
  }

  String tUnknown() {
    if (getLanguage() == 'AR') {
      return "غير معروف";
    } else if (getLanguage() == 'EN') {
      return "Unknown";
    } else {
      return "inconnu";
    }
  }

  String tTrailerStatus() {
    if (getLanguage() == 'AR') {
      return "حالة المقطورة";
    } else if (getLanguage() == 'EN') {
      return "Trailer Status";
    } else {
      return "Statut de Remorque";
    }
  }

  String tSubscribeSocialMedia() {
    if (getLanguage() == 'AR') {
      return "اشترك معنا _ اتصل بنا ";
    } else if (getLanguage() == 'EN') {
      return "Contact Us:";
    } else {
      return "Abonnez-vous _ contactez-nous";
    }
  }

  String tTrailerCharge() {
    if (getLanguage() == 'AR') {
      return "حمولة المقطورة";
    } else if (getLanguage() == 'EN') {
      return "Trailer charge";
    } else {
      return "Charge de Remorque";
    }
  }

  String tDeviceInactive() {
    if (getLanguage() == 'AR') {
      return "الجهاز غير نشط";
    } else if (getLanguage() == 'EN') {
      return "Device Inactive";
    } else {
      return "Appareil inactif";
    }
  }

  String tDeviceOverSpeed() {
    if (getLanguage() == 'AR') {
      return "مركبة السرعة الزائدة";
    } else if (getLanguage() == 'EN') {
      return "Device Over Speed";
    } else {
      return "Appareil Survitesse";
    }
  }

  String tDeviceFuelDrop() {
    if (getLanguage() == 'AR') {
      return "انخفاض الوقود";
    } else if (getLanguage() == 'EN') {
      return "Device Fuel Drop";
    } else {
      return "Chute de Carburant ";
    }
  }

  String tAlarm() {
    if (getLanguage() == 'AR') {
      return "إنذار";
    } else if (getLanguage() == 'EN') {
      return "Alarm";
    } else {
      return "Alarm";
    }
  }

  String tGeoFenceEnter() {
    if (getLanguage() == 'AR') {
      return "دخول السياج الجغرافي";
    } else if (getLanguage() == 'EN') {
      return "GeoFence Enter";
    } else {
      return "Entree dans geo-fence";
    }
  }

  String tGeoFenceExit() {
    if (getLanguage() == 'AR') {
      return "خروج السياج الجغرافي";
    } else if (getLanguage() == 'EN') {
      return " GeoFence Exit";
    } else {
      return "Sortie de geo-fence";
    }
  }

  String tGeoFenceName() {
    if (getLanguage() == 'AR') {
      return "  اسم السياج الجغرافي";
    } else if (getLanguage() == 'EN') {
      return " GeoFence Name";
    } else {
      return "Nom de Geofence";
    }
  }

  String tGeoFenceDescription() {
    if (getLanguage() == 'AR') {
      return "وصف السياج الجغرافي";
    } else if (getLanguage() == 'EN') {
      return " Description";
    } else {
      return "Description";
    }
  }

  String tIgnitionOn() {
    if (getLanguage() == 'AR') {
      return "تشغيل اشتعال المحرك";
    } else if (getLanguage() == 'EN') {
      return "Ignition On";
    } else {
      return "Moteur Allumé";
    }
  }

  String tYes() {
    if (getLanguage() == 'AR') {
      return "نعم";
    } else if (getLanguage() == 'EN') {
      return "YES";
    } else {
      return "OUI";
    }
  }

  String tNo() {
    if (getLanguage() == 'AR') {
      return "لا";
    } else if (getLanguage() == 'EN') {
      return "NO";
    } else {
      return "NON";
    }
  }

  String tClose() {
    if (getLanguage() == 'AR') {
      return "مقفل";
    } else if (getLanguage() == 'EN') {
      return "Closed";
    } else {
      return "Fermé";
    }
  }

  String tOpen() {
    if (getLanguage() == 'AR') {
      return "مفتوح";
    } else if (getLanguage() == 'EN') {
      return "Open";
    } else {
      return "Ouvert";
    }
  }

  String tIgnitionOff() {
    if (getLanguage() == 'AR') {
      return "إيقاف اشتعال المحرك";
    } else if (getLanguage() == 'EN') {
      return "Ignition Off";
    } else {
      return "Allumage du Moteur Coupé";
    }
  }

  String tIgnition() {
    if (getLanguage() == 'AR') {
      return "اشتعال المحرك";
    } else if (getLanguage() == 'EN') {
      return "Ignition";
    } else {
      return "Allumage";
    }
  }
}