unit CommDemo.ResourceStr;

interface

resourcestring
  sAutoCalcFmt = '������ �� ������ ����� (%d)';

  sNewSample = '�����: �����';
  sNewSampleCopyFmt = '�����: ����� (����� %s)';
  sNewSampleChosen = '�����: �������';

  sTab = AnsiChar(#9);
  sNewline = AnsiString(#13#10);

  sConfigNotExists = '���� �������� %s �� ���������. ��������� ����� �������.';
  sConfigOpenFail = '������������ ���� %s. ��������� ����� �������.';

  // CommDemo.Main.pas
  sUstingMode = '����� ���������';
  sUstingModeOff = '�������� ����� ���������';

  sWinRegTitle = '����������� - ';

  sNoCon = '�� ����������.';
  sNoAlarm = '��� �������. ';
  sFirstAlarm = ' - ������ �������';
  sCurrentAlarm = #13;
  sLastAlarm = '��������� �������: ';

  s_ML = ' ��';

  // uAnalizParal.pas
  sTotalExpTime = '����� ����� ����������................ ';
  sTransferSpeed = '�������� ������....................... ';
  sMklM = '���/�';
  sRegSampleVol = '����� ����� ������������������ �����.. ';
  sAnalizDate = '���� �������: ';
  sRepColumnHdr = '   �����    ���      N          S             M2            M3            M4';
  sElemConcentr = '     ������������ ���������';
  sRepColumnHdr2 = '�����   � ����.,�/�   � � ��������,�/�  �����.,�.�.  ����.,���   �����,���.';
  sSostavChastIznosa = '      ������ ������ ������';
  sRepColumnHdr3 = '��� ������               ����������';

  // CommDemo.Registration.Main.pas
  sExposReg = '���������� - ����������� ����� �';
  sParalN = ' ������������ �';
  sEdD = ' ��/�';
  smVD = ' mV/�';
  sSaveEtalFon = '��������� �������� ���';
  sRegStdBGS = '����������� ���������� ���� ������';
  sExposRegEtFon = '���������� - ����������� ���������� ���� ������';
  sExposRegStd = '���������� - ����������� ���������';
  sExposCfg = '���������� - ���������';

  // uSetSampleParam.pas
  sSampleExistsParal = '����� � ����� ������� ��� ����. ���������� ����������� ������������?';
  sTypeSampleCode = '������� ��� �����';
  sTypeSampleType = '������� ��� �����';
  sTypeSampleDate = '������� ���� ������ �����';
  sTypeEngineN = '������� ����� ���������';
  sTypePPR = '������� ��� ���';
  sTypeCompany = '������� ��������';
  sPrPoint = '����� ������';
  sLiquid = '��������';
  sLiquidType = '��� ��������';
  sAviacomp = '������������';
  sNEngine = '� ���������';
  sTypeEngine = '��� ���������';
  sValue = '��������';

  // uBase.pas
  sSampleDeleteConf = '�� ������������� ������ ������� ����� �';
  sSampleDeleteConf2 = '����������� �������� ����� �';
  sNoRightsToDelete = '� ��� ��� ���� �� ��������!';
  sEditSample = '�������������� ����� - ';
  sEditEngine = '�������������� ���������� ��������� - ';
  sModelNbr = '������ �';
  sModelNotFound = '������ �� �������';
  sModelRebuildConf = '�� ������������� ������ ����������� ������ �%d?';
  sModelDeleteConf = '��������!!! ������� ������ �%d?';
  sModelRecalcConfFmt = '��������!!! ����������� ���������, �������� � ����������  ������ �%d (����� ������ ��������� �����)?';

  // uCopyToClpBoard.pas
  sNoMemToCopy = '������������ ������ ��� ����������� ���������� � ����� ������';

implementation

end.
