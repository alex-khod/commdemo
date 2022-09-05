#ifndef _UART_H
#define _UART_H

    //���������� ������� ������������ ���� ��� ����������� ������������� "����������" �������� � ������ � ��� �� ��������.
    #include "main.h"   //�������� ������� - ������ � ���������������� ����� define	FCY

    #define DELAY_105uS asm volatile ("REPEAT, #4201"); Nop(); // 105uS delay

//_____________________________________________________________________________________
// ����������� ��������
    //��� ����� � �� ����� FTDI ������������ UART1
    #define BAUDRATE                 115200         //�������� ������ UART
    #define TX_BUFSIZE               2048           //������ ����������� ������������ ������
    #define RX_BUFSIZE               2048           //������ ������������ ������������ ������
    #define MAX_TX_DATA_SIZE         250             //������������ ������ ������� ������������ ������   // ������ ������������ ������������ �������
    #define MAX_RX_DATA_SIZE         250             //������������ ������ ������� ����������� ������    // ������ ������������ ����������� ������� � �� (���� ����������� ������)*2 �� ������ ���������
    //#define TX_LOW_BYTE_FIRST                       //������ Data ������������ �� �������� ���������� � ������� - ������� ���� ������
    #define TX_HIGHT_BYTE_FIRST                     //������ Data ������������ �� �������� ���������� � ������� - ������� ���� ������
    //#define RX_LOW_BYTE_FIRST                       //������ Data ������������ �� �������� ���������� � ������� - ������� ���� ������
    #define RX_HIGHT_BYTE_FIRST                     //������ Data ������������ �� �������� ���������� � ������� - ������� ���� ������
    #define WAKE_TX_PACKET  //���������� Wake �������� ��� �������� - ��. ����������� - � ����� �����(��������������� ��� ������)

    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ���������� (�������) ������ ������ UART (������ � ������������ � ������������ - ��� ���������� ��� ������������� � ������� InitUart() )
    #define PPS_U1TX_FUNC       3                   // PIC24FJ256GA110 Family Data Sheet (TABLE 10-3)output function
    #define PPS_U1RX_REG        RPINR18bits.U1RXR   // PIC24FJ256GA110 Family Data Sheet (TABLE 10-2)

    #define PPS_U1TX_PIN        RPOR14bits.RP29R    //UART1 TX pin  // PIC24FJ256GA110 Family Data Sheet //Setting the RPORx register with the listed value assigns that output function to the associated RPn pin.
    #define PPS_U1RX_PIN        14                  //UART1 RX pin
    //RP29 � RP14
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ���������� ���������� ������, ���� � ���������� ��������� ������������ PR ����� �������������� ��� ���������� ����� AN (������ ��� ������������� � ������� InitUart() )
    //	PIC24FJ256GA110 Family Data Sheet (10.4.2.1 Peripheral Pin Select Function Priority)
    #define AN_U1TX     AD1PCFGLbits.PCFG15         //������ ��� ������ RP14 - ����� �������������� ��� AN14
    #define AN_U1RX     AD1PCFGLbits.PCFG14         //PIC24FJ256GA110 Family Data Sheet//REGISTER 21-5: AD1PCFGL: A/D PORTCONFIGURATION REGISTER (LOW) //REGISTER 21-6: AD1PCFGH: A/D PORTCONFIGURATION REGISTER (HIGH)

    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // ���������� ��������� ������ UART ��� ������   (������ ��� ������������� � ������� InitUart() )
    //��������� ��������� ������ ����� ������������� ������������ UARTEN_U1 � UTXEN_U1
    #define U1MODE_VAL          0x2000  //0010000000000000   - ��. ����������� - � ����� �����
    #define USE_HI_SPEED_BRG

    #ifdef  USE_HI_SPEED_BRG
        #define BRGH_VAL        1       //High-Speed mode (baud clock generated from FCY/4)
        #define BRG_DIV         4       //�������� ��� ������� BAUDRATEREG
     #else
        #define BRGH_VAL        0       //Standard mode (baud clock generated from FCY/16
        #define BRG_DIV         16      //�������� ��� ������� BAUDRATEREG
     #endif

    #define U1STA_VAL           0       //0000000000000000  - ��. ����������� - � ����� �����
    #define U1BRG_VAL                  ((FCY + (BRG_DIV/2*BAUDRATE))/BRG_DIV/BAUDRATE-1)

    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // �������� ��� �����������
    #define BAUD_ACTUAL                  (FCY/BRG_DIV/(U1BRG_VAL+1))//������� ������������� �������� UART ��� ����������� �������� BAUDRATEREG (U1BRG)
    #define BAUD_ERROR                   ((BAUD_ACTUAL > BAUDRATE) ? BAUD_ACTUAL-BAUDRATE : BAUDRATE-BAUD_ACTUAL)//���������� ����������� ��������� ��������
    #define BAUD_ERROR_PRECENT           ((BAUD_ERROR*100+BAUDRATE/2)/BAUDRATE)	// ������������� ����������� ��������� ��������
    #if (BAUD_ERROR_PRECENT_U1 > 3)
        #error "UART1 frequency error is worse than 3%"
    #elif (BAUD_ERROR_PRECENT_U1 > 2)
        #warning "UART1 frequency error is worse than 2%"
    #endif
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _   
//_____________________________________________________________________________________
// ����������� �����
    typedef union{
        unsigned long Long;
        unsigned short int  Int[2] __PACKED;
        unsigned char Char[4] __PACKED;
    }Long_t;

    typedef struct {
        unsigned char Data[TX_BUFSIZE];
        volatile unsigned short int RdIndex;//������ ������ ������ � ���������� ����������� ������ TxBuffer ������ ����� ������ ���� ISR - void __attribute__((interrupt, no_auto_psv)) _U1TXInterrupt (void);
        volatile unsigned short int WrIndex;//������ ������ ������ � ���������� ����������� ������ TxBuffer ���� ����� ������� ���� ��� ������ �������
    }Tx_Buffer_t;

    typedef struct {
        unsigned char Address;
        unsigned char Command;
        unsigned char DataLength;
        unsigned char Data[MAX_TX_DATA_SIZE];
        unsigned char Crc;
    } Tx_Packet_t;

    typedef struct{
        Tx_Buffer_t Buffer;
        Tx_Packet_t Packet;
        unsigned char *pntTxPackData;//��������� ������ ���� ����� ������� ���� ������ ��� ������������ ������ �� ��������(��. packet.c )
        unsigned char *pntTxPacketByte;//��������� ������ ����� �� ��������
    }Tx_t;


    typedef struct {
        unsigned char Data[RX_BUFSIZE];
        volatile unsigned short int RdIndex;
        volatile unsigned short int WrIndex;
    }Rx_Buffer_t;

    typedef struct{//��������� ������ ������ ����������� � ������� ReadAndAnalyseRxPackets(void) ����� uart.c
        unsigned char Address;
        unsigned char Command;
        unsigned char DataLength;
        unsigned char Data[MAX_RX_DATA_SIZE];
        unsigned char Crc;
    }Rx_Packet_t;

    typedef struct {//��������� ���������� ������������ ��� ������� ������ � ���������� ������ � ������� ReadAndAnalyseRxPackets(void) ����� uart.c
        unsigned char *pntRxPacketByte;
        unsigned char StartPacket;
        unsigned char Fesc;
        unsigned char CrcControl;
    }Rx_Analyse_t;

    typedef struct{
        Rx_Buffer_t Buffer;
        Rx_Packet_t Packet;
        Rx_Analyse_t Analyse;
        unsigned char RxPackDataPointer;            //����� ����� � �������� ������ ������ ����� ������ ���� ��� ���������� ReadDataFromRxPacket()
        Long_t RxPackDataToRead;                    //��������� ��������� ��� ������ ������� ����������� �������� ReadDataFromRxPacket()
    }Rx_t;

    typedef struct{
        Tx_t Tx;
        Rx_t Rx;
    }Uart_t;
//_____________________________________________________________________________________
// ���������� ����������
    extern Uart_t Uart;
//_____________________________________________________________________________________
// ���������� �������

    void InitUart(void);
    void EnableUart(void);   
    void WriteByteToTxBuffer(unsigned char data);
    void SendTxPaket(void);
    void AnalyseRxBuffer(void);
    void __attribute__((interrupt, no_auto_psv)) _U1TXInterrupt(void);
    void __attribute__((interrupt, no_auto_psv)) _U1RXInterrupt(void);

    void Putch(unsigned char txbyte);
    unsigned char Getch(unsigned char *rxbyte);
//_____________________________________________________________________________________
// �������
    #define EnUart()            U1MODEbits.UARTEN   =1;     //UARTx is enabled; all UARTx pins are controlled by UARTx as defined by UEN<1:0>
    #define DisUart()           U1MODEbits.UARTEN   =0;     //UARTx is disabled; all UARTx pins are controlled by port latches; UARTx power consumption is minimal

    #define EnUartTx()          U1STAbits.UTXEN     =1;     //Transmit enabled; UxTX pin controlled by UARTx
    #define DisUartTx()         U1STAbits.UTXEN     =0;     //Transmit disabled; any pending transmission is aborted and the buffer is reset, UxTX pin controlled by port.
                                                            //Also sets the U1TXIFbit => SetFlagTxInt() !!!causes a transmit interrupt two cycles after being set

    #define EnUartTxInt()      IEC0bits.U1TXIE     =1;     //�������� ���������� �� ������ UART1
    #define EnUartRxInt()      IEC0bits.U1RXIE     =1;     //�������� ���������� �� �������� UART1
    #define DisUartTxInt()     IEC0bits.U1TXIE     =0;     //��������� ���������� �� ������ UART1
    #define DisUartRxInt()     IEC0bits.U1RXIE     =0;     //��������� ���������� �� �������� UART1

    #define ClearFlagTxInt()   IFS0bits.U1TXIF     =0;     //�������� ���� ���������� �� �������� UART1
    #define ClearFlagRxInt()   IFS0bits.U1RXIF     =0;     //�������� ���� ���������� �� ������ UART1
    #define SetFlagTxInt()     IFS0bits.U1TXIF     =1;     //���������� ���� ���������� �� �������� UART1
    #define SetFlagRxInt()     IFS0bits.U1RXIF     =1;     //���������� ���� ���������� �� ������ UART1
#endif//END #ifndef _UART_H

//�����������//_____________________________________________________________________________________
/*
    *  ���������� U1MODE_VAL//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //U1MODE //PIC24FJ256GA110 Family Data Sheet (REGISTER 17-1: UxMODE: UARTx MODE REGISTER)
    *  U1MODEbits.UARTEN       (POR=0)     = 0;    //UARTx is disabled; all UARTx pins are controlled by port latches; UARTx power consumption is minimal
    *  -U                      (POR=0)     = 0;
    *  U1MODEbits.USIDL        (POR=0)     = 0;    //Discontinue module operation when the device enters Idle mode
    *  U1MODEbits.IREN         (POR=0)     = 1;    //IrDA encoder and decoder disabled
    *  U1MODEbits.RTSMD        (POR=0)     = 0;    //UxRTSpin in Flow Control mode
    *  -U                      (POR=0)     = 0;
    *  U1MODEbits.UEN1         (POR=0)     = 0;
    *  U1MODEbits.UEN0         (POR=0)     = 0;
    // U1MODEbits.UEN<1:0>               = 0//   //UxTX and UxRX pins are enabled and used; UxCTSand UxRTS/BCLKx pins controlled by port latches
    *  U1MODEbits.WAKE     -R/C(POR=0)     = 0;    //No wake-up enabled
    *  U1MODEbits.LPBACK       (POR=0)     = 0;    //Loopback mode is disabled
    *  U1MODEbits.ABAUD        (POR=0)     = 0;    //Baud rate measurement disabled or completed
    *  U1MODEbits.RXINV        (POR=0)     = 0;    //UxRX Idle state is �1�
    *  U1MODEbits.BRGH         (POR=0)     = 0;    //Standard mode (baud clock generated from FCY/16)
    *  U1MODEbits.PDSEL1       (POR=0)     = 0;
    *  U1MODEbits.PDSEL0       (POR=0)     = 0;
    // U1MODEbits.PDSEL<1:0>             = 0;//  //8-bit data, no parity
    *  U1MODEbits.STSEL        (POR=0)     = 0;    //One Stop bit
 *
    * ���������� U1STA_VAL//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //PIC24FJ256GA110 Family Data Sheet (REGISTER 17-2: UxSTA: UARTx STATUS AND CONTROL REGISTER)
    * U1STAbits.UTXISEL1       (POR=0)    = 0;
    * U1STAbits.UTXINV         (POR=0)    = 0;    //Value of bit only affects the transmit properties of the module when the IrDAencoder is enabled (IREN =1)
    * U1STAbits.UTXISEL0       (POR=0)    = 0;
    // U1STAbits.UTXISEL<1:0>            = 00;   //Interrupt when a character is transferred to the Transmit Shift Register (this implies there is at least one character open in the transmit buffer)
    * -U                       (POR=0)    = 0;
    * U1STAbits.UTXBRK         (POR=0)    = 0;    //Sync Break transmission disabled or completed
    * U1STAbits.UTXEN          (POR=0)    = 0;    //Transmit disabled; any pending transmission is aborted and the buffer is reset, UxTX pin controlled by port
    * U1STAbits.UTXBF        -R(POR=0)    = 0;    //Transmit buffer is not full; at least one more character can be written
    * U1STAbits.TRMT         -R(POR=1)    = 0;    //Transmit Shift Register is empty and transmit buffer is empty (the last transmission has completed)
    * U1STAbits.URXISEL1       (POR=0)    = 0;
    * U1STAbits.URXISEL0       (POR=0)    = 0;
    // U1STAbits.URXISEL<1:0>            = 00;   //Interrupt is set when any character is received and transferred from the RSR to the receive buffer.Receive buffer has one or more characters.
    * U1STAbits.ADDEN          (POR=0)    = 0;    //Address Detect mode disabled
    * U1STAbits.RIDL         -R(POR=1)    = 0;
    * U1STAbits.PERR         -R(POR=0)    = 0;
    * U1STAbits.FERR         -R(POR=0)    = 0;
    * U1STAbits.OERR       -R/C(POR=0)    = 0;    //Receive buffer has not overflowed (clearing a previously set OERR bit (1->0 transition) will reset the receiver buffer and the RSR to the empty state)
    * U1STAbits.URXDA        -R(POR=0)    = 0;
 *
    * ����������� WAKE_TX_PACKET//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    * ��� �������� ������������ ������������ ������������ ������ ���� ����������� ��������� Wake ��� ��������.
    * ������������ ����� ��� Wake ������� �� ����������� ������:
     * 1.�ddress
     * 2.Command
     * 3.DataLength
     * 4.Data
     * 5.CRC(��� ���������� FEND)
     * �������� �� �����������
 */
