#ifndef _PACKET_H
#define _PACKET_H

#include "uart.h"
//_____________________________________________________________________________________
//����������� ��������
    //��������� ���� ���������� ��� ������ ������ � ���������� �� �������� ����� (������� MoveDataToTxPacket())
    #define CHAR            0
    #define INT             1
    #define LONG            2
//_____________________________________________________________________________________
//���������� �������
    void StartTxPacket(unsigned char address,unsigned char command);
    void MoveDataToTxPacket(unsigned char type, long data);
    void EndTxPacket(void);
    void ReadDataFromRxPacket(unsigned char type);
//_____________________________________________________________________________________
// ����������� ��������
    #define StartReadRxData()     Uart.Rx.RxPackDataPointer = 0;
#endif//END #ifndef _TXPACK_H

