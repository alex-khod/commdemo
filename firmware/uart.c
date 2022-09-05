#include "uart.h"
#include "crc.h"
#include "wake.h"

Uart_t Uart;

//��� ��������� ������������� InitUart() ������������ � ����� uart.h !!!
//_____________________________________________________________________________________

void InitUart(void) {// ������� ������������� UART �������
    unsigned char *i;

#ifdef AN_U1TX
    AN_U1TX = 1; //��� �������� ����//PIC24FJ256GA110 Family Data Sheet//REGISTER 21-5: AD1PCFGL: A/D PORTCONFIGURATION REGISTER (LOW)//REGISTER 21-6: AD1PCFGH: A/D PORTCONFIGURATION REGISTER (HIGH)
#endif
#ifdef AN_U1RX
    AN_U1RX = 1;
#endif
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ������� �������
    __builtin_write_OSCCONL(OSCCON & 0xbf); //Unlock Sequence
    PPS_U1RX_REG = PPS_U1RX_PIN; // ��������� PPS_U1RX_PIN ������ PPS_U1RX_REG
    PPS_U1TX_PIN = PPS_U1TX_FUNC; // ��������� PPS_U1TX_PIN ������� ������ PPS_U1TX_FUNC
    __builtin_write_OSCCONL(OSCCON | 0x40); //Lock Sequence
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //���� � ���������� ��������� ������������ PR ����� �������������� ��� ���������� ����� AN
    //�������� ��� ����� ��� ��������

    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ��������� ������ ������
    U1MODE = 0x0000;
    U1STA = 0x0000;
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //�������� ������� U1MODE //PIC24FJ256GA110 Family Data Sheet (REGISTER 17-1: UxMODE: UARTx MODE REGISTER)
    U1MODE = U1MODE_VAL;
    U1MODEbits.BRGH = BRGH_VAL;
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //�������� ������� U1STA  //PIC24FJ256GA110 Family Data Sheet (REGISTER 17-2: UxSTA: UARTx STATUS AND CONTROL REGISTER)
    U1STA = U1STA_VAL;
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //������� �������� � ������� ��������
    U1BRG = U1BRG_VAL;
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ��������� ����������
    DisUartTxInt();
    DisUartRxInt();
    ClearFlagTxInt();
    ClearFlagTxInt();
    //��������� ����������� �������� � ��������� ���� interruptpriority.c
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ��������� ��������� ������� ��������� � ����������� ����������� �������
    Uart.Tx.Buffer.RdIndex = 0;
    Uart.Tx.Buffer.WrIndex = 0;
    Uart.Rx.Buffer.RdIndex = 0;
    Uart.Rx.Buffer.WrIndex = 0;

    Uart.Rx.Analyse.pntRxPacketByte = &Uart.Rx.Packet.Address;
    Uart.Rx.Analyse.StartPacket = NO;
    Uart.Rx.Analyse.Fesc = NO;
    Uart.Rx.Analyse.CrcControl = 0;

    i = &Uart.Tx.Buffer.Data[0];
    while (i <= (unsigned char*) &Uart.Tx.Buffer.Data[TX_BUFSIZE - 1]) {
        *i = 0;
        i++;
    }

    i = &Uart.Tx.Packet.Address;
    while (i <= (unsigned char*) &Uart.Tx.Packet.Crc) {
        *i = 0;
        i++;
    }

    i = &Uart.Rx.Buffer.Data[0];
    while (i <= (unsigned char*) &Uart.Rx.Buffer.Data[RX_BUFSIZE - 1]) {
        *i = 0;
        i++;
    }

    i = &Uart.Rx.Packet.Address;
    while (i <= (unsigned char*) &Uart.Rx.Packet.Crc) {
        *i = 0;
        i++;
    }


}//END InitUart()
//_____________________________________________________________________________________

void EnableUart(void) {//������� ��������� ������ UART1

    EnUart();
    EnUartTx(); //Enable Transmit UART1 !!!causes a transmit interrupt two cycles after being set
    DELAY_105uS;
    ClearFlagTxInt(); //������� ���� ���������� �� �������� UART1
    ClearFlagRxInt(); //������� ���� ���������� �� ������ UART1 - ��������� ��� ��� ���������� �������� ����� UART
    EnUartTxInt(); //������� ���������� �� �������� UART1
    EnUartRxInt(); //������� ���������� �� ������ UART1
    SetFlagRxInt(); //������� ����� UART
    SetFlagRxInt();
    SetFlagRxInt();
    SetFlagRxInt();
}//END EnableUart1()
//_____________________________________________________________________________________

void WriteByteToTxBuffer(unsigned char data) {//������� �������� ������ �����
    if ((U1STAbits.UTXBF == 0) && (Uart.Tx.Buffer.RdIndex == Uart.Tx.Buffer.WrIndex)) { // ���� ����� ��� ���� �� ������ ����� � ���������� ������ � ��� ���� �� �������� � �����������
        U1TXREG = data; // ���������� ���� � ���������� ���������� �����
    } else {
        if (Uart.Tx.Buffer.WrIndex == (TX_BUFSIZE - 1)) { // ������ ������ ��������� ��������� ������ � ����.������
            while (Uart.Tx.Buffer.RdIndex == 0) { // ���� ����� ����������� �����
            }
        } else { // �� � �����
            while ((Uart.Tx.Buffer.WrIndex + 1) == Uart.Tx.Buffer.RdIndex) { // ���� ����� ����������� �����
            }
        }
        Uart.Tx.Buffer.Data[Uart.Tx.Buffer.WrIndex] = data;
        if (Uart.Tx.Buffer.WrIndex == (TX_BUFSIZE - 1)) {
            Uart.Tx.Buffer.WrIndex = 0;
        } else {
            Uart.Tx.Buffer.WrIndex++;
        }
    }
}//END WriteByteToTxBuffer()
//_____________________________________________________________________________________

void SendTxPaket(void) {//������� �������� ������ �� ��������� Uart.Tx.Packet.Struct � ����������� ���������� �����.
    Uart.Tx.pntTxPacketByte = &Uart.Tx.Packet.Address;
    while (Uart.Tx.pntTxPacketByte <= &Uart.Tx.Packet.Crc) {
#ifdef WAKE_TX_PACKET   //��������������� � ����� uart.h ����� ��������� Wake ��� ��������
        SendWakeTxByte();
#else
        WriteByteToTxBuffer(*Uart.Tx.pntTxPacketByte);
#endif
        Uart.Tx.pntTxPacketByte++;
        if (Uart.Tx.pntTxPacketByte == (unsigned char*) &Uart.Tx.Packet.Data[0] + Uart.Tx.Packet.DataLength) {
            Uart.Tx.pntTxPacketByte = &Uart.Tx.Packet.Crc;
        }
    }
}//END SendTxPaket()
//_____________________________________________________________________________________

void __attribute__((interrupt, no_auto_psv)) _U1TXInterrupt(void) {
    ClearFlagTxInt();
    if (Uart.Tx.Buffer.RdIndex != Uart.Tx.Buffer.WrIndex) { // ���� ������ �� �������� � ����������� ������
        U1TXREG = Uart.Tx.Buffer.Data[Uart.Tx.Buffer.RdIndex];
        if (Uart.Tx.Buffer.RdIndex == (TX_BUFSIZE - 1)) {
            Uart.Tx.Buffer.RdIndex = 0;
        } else {
            Uart.Tx.Buffer.RdIndex++;
        }
    }
}//END _U1TXInterrupt(void)

//����
//_____________________________________________________________________________________

void __attribute__((interrupt, no_auto_psv)) _U1RXInterrupt(void) {

    ClearFlagRxInt();
    while (U1STAbits.URXDA == 1) {
        Uart.Rx.Buffer.Data[Uart.Rx.Buffer.WrIndex] = U1RXREG;
        if (Uart.Rx.Buffer.WrIndex == RX_BUFSIZE - 1) {
            //        while (Uart.Rx.Buffer.RdIndex == 0) {
            //        };
            Uart.Rx.Buffer.WrIndex = 0;
        } else {
            //        while (Uart.Rx.Buffer.WrIndex + 1 == Uart.Rx.Buffer.RdIndex) {
            //        };
            Uart.Rx.Buffer.WrIndex++;
        }
    }
}//END _U1RXInterrupt ()
//_____________________________________________________________________________________

void AnalyseRxBuffer(void) {

    unsigned short int WrIndex;

    WrIndex = Uart.Rx.Buffer.WrIndex;

    while (Uart.Rx.Buffer.RdIndex != WrIndex) {//���� �� ������
        if (Uart.Rx.Buffer.Data[Uart.Rx.Buffer.RdIndex] == FEND) {
            Uart.Rx.Analyse.StartPacket = YES;
            Uart.Rx.Analyse.pntRxPacketByte = &Uart.Rx.Packet.Address;
            Uart.Rx.Analyse.Fesc = NO;
        } else {
            if (Uart.Rx.Analyse.StartPacket == YES) {
                if (Uart.Rx.Analyse.Fesc == NO) {
                    if (Uart.Rx.Buffer.Data[Uart.Rx.Buffer.RdIndex] == FESC) {
                        Uart.Rx.Analyse.Fesc = YES;
                    } else {
                        *Uart.Rx.Analyse.pntRxPacketByte = Uart.Rx.Buffer.Data[Uart.Rx.Buffer.RdIndex];
                        Uart.Rx.Analyse.pntRxPacketByte++;
                    }
                } else {//fesc = YES
                    if (Uart.Rx.Buffer.Data[Uart.Rx.Buffer.RdIndex] == TFEND) {
                        *Uart.Rx.Analyse.pntRxPacketByte = FEND;
                        Uart.Rx.Analyse.pntRxPacketByte++;
                        Uart.Rx.Analyse.Fesc = NO;
                    } else {
                        if (Uart.Rx.Buffer.Data[Uart.Rx.Buffer.RdIndex] == TFESC) {
                            *Uart.Rx.Analyse.pntRxPacketByte = FESC;
                            Uart.Rx.Analyse.pntRxPacketByte++;
                            Uart.Rx.Analyse.Fesc = NO;
                        } else {
                            Uart.Rx.Analyse.StartPacket = NO;
                        }
                    }
                }
                if (Uart.Rx.Analyse.pntRxPacketByte == &Uart.Rx.Packet.Address + 1) {
                    Uart.Rx.Packet.Address &= 0x7F;
                }
                if (Uart.Rx.Analyse.pntRxPacketByte == &Uart.Rx.Packet.Crc + 1) {
                    Uart.Rx.Analyse.CrcControl = CRC8_calculate(WAKE_PACK, RX_PACK);
                    if (Uart.Rx.Analyse.CrcControl == Uart.Rx.Packet.Crc) {
                        AnalyseRxPacket();
                    }
                    Uart.Rx.Analyse.StartPacket = NO;
                }
                if (Uart.Rx.Analyse.pntRxPacketByte > &Uart.Rx.Packet.DataLength) {
                    if (Uart.Rx.Analyse.pntRxPacketByte == &Uart.Rx.Packet.Data[0] + Uart.Rx.Packet.DataLength) {
                        Uart.Rx.Analyse.pntRxPacketByte = &Uart.Rx.Packet.Crc;
                    }
                }
            }
        }
        if (Uart.Rx.Buffer.RdIndex == RX_BUFSIZE - 1) {
            Uart.Rx.Buffer.RdIndex = 0;
        } else {
            Uart.Rx.Buffer.RdIndex++;
        }
    }
}
//_____________________________________________________________________________________

void Putch(unsigned char txbyte) {//������� �������� ������ ����� �� UART1 !!!���� �� ������������ ����������
    while (U1STAbits.UTXBF); //U1STAbits.UTXBF = 1 = Transmit buffer is ful -> wait for FIFO spac
    U1TXREG = txbyte; //put character onto UART FIFO to transmit
}//END PutCharUart()
//_____________________________________________________________________________________

unsigned char Getch(unsigned char *rxbyte) {//������� ������ ������ ����� �� UART1 !!!���� �� ������������ ����������
    while (!U1STAbits.URXDA); //U2STAbits.URXDA = 0 = Receive buffer is empty ->//wait for  = 1= Receive buffer has data; at least one more character can be read;
    *rxbyte = U1RXREG;
}//END GetCharUart()

