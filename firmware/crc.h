#ifndef _CRC_H
#define _CRC_H

//_____________________________________________________________________________________
//����������� ��������
    #define SIMPLE_PACK         0   //CRC ������������� ��� �������� ������
    #define WAKE_PACK           1   //CRC ������������� ��� Wake ������

    #define TX_PACK             0   //CRC ������������� ��� Tx ������
    #define RX_PACK             1   //CRC ������������� ��� Rx ������

//_____________________________________________________________________________________
//���������� ����������
    extern const unsigned char CRC_TABLE[256];

//_____________________________________________________________________________________
//����������� �������
    unsigned char CRC8_calculate(unsigned char type,unsigned char packet);
#endif//END #ifndef _CRC_H
