#ifndef _WAKE_H
#define _WAKE_H

//_____________________________________________________________________________________
//����������� ��������
    //��������� ���� ��������� Wake - ��. ������������ Wake �������� �������� ������
    #define FEND    0xC0    //������ ������
    #define FESC    0xDB    
    #define TFEND   0xDC
    #define TFESC   0xDD
//_____________________________________________________________________________________
//���������� �������
    void SendWakeTxByte(void); // ��. ����������� - � ����� �����
    void StuffingSend(unsigned char byte);
#endif//END #ifndef _WAKE_H 
    

