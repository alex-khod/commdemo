#include "wake.h"

#include "uart.h"
#include "crc.h"
//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
//void WakeData(unsigned char byte_number)
//
//������ � Tx.Packet.Struct (��. UART.h ) ������������� � �������
//��������������� ����������� ����������� ������ � Wake ������:
//Address,Command,DataLength,Data[DataLength],Crc
//������� Wake() ���������� ������ ����� �� ������������ Wake ������ �������� ������������ �� Wake �������� � ���������� ��� � ����������� ���������� �����

void SendWakeTxByte(void){
    unsigned char temp;
    if(Uart.Tx.pntTxPacketByte == & Uart.Tx.Packet.Address){
        Uart.Tx.Packet.Crc = CRC8_calculate(WAKE_PACK,TX_PACK);
        WriteByteToTxBuffer(FEND);//������ Wake ������
        temp = Uart.Tx.Packet.Address|0x80;//������� ��� ����� ������ � �������
    }else
    if(Uart.Tx.pntTxPacketByte == & Uart.Tx.Packet.Command){
        temp = Uart.Tx.Packet.Command&0x7F;//������� ��� ����� ������� � ����
    }else{
        temp = *Uart.Tx.pntTxPacketByte;
    }
    StuffingSend(temp);//��������������� ����� ��������� ��������
    return;
}//END WakeData()
//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
void StuffingSend(unsigned char byte){
    if(byte == FEND){
       WriteByteToTxBuffer(FESC);
       WriteByteToTxBuffer(TFEND);
    }else
    if(byte == FESC){
       WriteByteToTxBuffer(FESC);
       WriteByteToTxBuffer(TFESC);
    }else{
       WriteByteToTxBuffer(byte);
    }
}//END Stuffing()

