unit CommDemo.ResourceStr;

interface

resourcestring
  sAutoCalcFmt = 'расчет по объему пробы (%d)';

  sNewSample = 'Проба: новая';
  sNewSampleCopyFmt = 'Проба: новая (копия %s)';
  sNewSampleChosen = 'Проба: выбрана';

  sTab = AnsiChar(#9);
  sNewline = AnsiString(#13#10);

  sConfigNotExists = 'Файл настроек %s не обнаружен. Программа будет закрыта.';
  sConfigOpenFail = 'Неккоректный файл %s. Программа будет закрыта.';

  // CommDemo.Main.pas
  sUstingMode = 'Режим юстировки';
  sUstingModeOff = 'Покинуть режим юстировки';

  sWinRegTitle = 'Регистрация - ';

  sNoCon = 'Не подключено.';
  sNoAlarm = 'Нет тревоги. ';
  sFirstAlarm = ' - первая тревога';
  sCurrentAlarm = #13;
  sLastAlarm = 'Последняя тревога: ';

  s_ML = ' мл';

  // uAnalizParal.pas
  sTotalExpTime = 'Общее время экспозиции................ ';
  sTransferSpeed = 'Скорость подачи....................... ';
  sMklM = 'мкл/м';
  sRegSampleVol = 'Объем пробы зарегистрированной пробы.. ';
  sAnalizDate = 'Дата анализа: ';
  sRepColumnHdr = '   Канал    Фон      N          S             M2            M3            M4';
  sElemConcentr = '     Концентрации элементов';
  sRepColumnHdr2 = 'Канал   С раст.,г/т   С в частицах,г/т  Крупн.,у.е.  Диам.,мкм   Масса,мкг.';
  sSostavChastIznosa = '      Состав частиц износа';
  sRepColumnHdr3 = 'Тип частиц               количество';

  // CommDemo.Registration.Main.pas
  sExposReg = 'Экспозиция - регистрация пробы №';
  sParalN = ' параллельная №';
  sEdD = ' Ед/д';
  smVD = ' mV/д';
  sSaveEtalFon = 'Запомнить эталоный фон';
  sRegStdBGS = 'Регистрация эталонного фона плазмы';
  sExposRegEtFon = 'Экспозиция - регистрация эталонного фона плазмы';
  sExposRegStd = 'Экспозиция - регистрация стандарта';
  sExposCfg = 'Экспозиция - настройка';

  // uSetSampleParam.pas
  sSampleExistsParal = 'Проба с таким номером уже есть. Продолжить регистрацию параллельных?';
  sTypeSampleCode = 'Введите код пробы';
  sTypeSampleType = 'Введите тип пробы';
  sTypeSampleDate = 'Введите дату отбора пробы';
  sTypeEngineN = 'Введите номер двигателя';
  sTypePPR = 'Введите ППР час';
  sTypeCompany = 'Введите компанию';
  sPrPoint = 'Точка отбора';
  sLiquid = 'Жидкость';
  sLiquidType = 'Тип жидкости';
  sAviacomp = 'Авиакомпания';
  sNEngine = '№ двигателя';
  sTypeEngine = 'Тип двигателя';
  sValue = 'Значение';

  // uBase.pas
  sSampleDeleteConf = 'Вы действительно хотите удалить пробу №';
  sSampleDeleteConf2 = 'Подтвердите удаление пробы №';
  sNoRightsToDelete = 'У Вас нет прав на удаление!';
  sEditSample = 'Редактирование пробы - ';
  sEditEngine = 'Редактирование параметров двигателя - ';
  sModelNbr = 'Модель №';
  sModelNotFound = 'Модель не найдена';
  sModelRebuildConf = 'Вы действительно хотите перестроить модель №%d?';
  sModelDeleteConf = 'ВНИМАНИЕ!!! Удалить модель №%d?';
  sModelRecalcConfFmt = 'ВНИМАНИЕ!!! Пересчитать протоколы, входящие в юрисдикцию  модели №%d (может занять некоторое время)?';

  // uCopyToClpBoard.pas
  sNoMemToCopy = 'Недостаточно памяти для копирования информации в буфер обмена';

implementation

end.
