#include "main.h"

#include "crc.h"
#include "packet.h"

#include "uart.h"
#include "timer.h"
#include "adc.h"
#include "pwm.h"

//_CONFIG2(IESO_ON  & FNOSC_FRCPLL & FCKSM_CSDCMD & OSCIOFNC_ON & IOL1WAY_OFF & POSCMOD_NONE);
//_CONFIG1(JTAGEN_OFF & GCP_OFF & GWRP_OFF & ICS_PGx1 & FWDTEN_OFF & WINDIS_OFF & FWPSA_PR32 & WDTPS_PS32768);

int CONFIG3 __attribute__((space(prog), address(0x157FA))) = 0xFFFF;
//_CONFIG3(
//    WPFP_WPFP511 &       // Write Protection Flash Page Segment Boundary (Highest Page (same as page 85))
//    WPDIS_WPDIS &        // Segment Write Protection Disable bit (Segmented code protection disabled)
//    WPCFG_WPCFGDIS &     // Configuration Word Code Page Protection Select bit (Last page(at the top of program memory) and Flash configuration words are not protected)
//    WPEND_WPENDMEM       // Segment Write Protection End Page Select bit (Write Protect from WPFP to the last page of memory)
//);
int CONFIG2 __attribute__((space(prog), address(0x157FC))) = 0xF18F;
//_CONFIG2(
//    POSCMOD_NONE &       // Primary Oscillator Select (Primary oscillator disabled)
//    IOL1WAY_OFF &        // IOLOCK One-Way Set Enable bit (Unlimited Writes To RP Registers)
//    OSCIOFNC_ON &        // Primary Oscillator Output Function (OSCO functions as port I/O (RC15))
//    FCKSM_CSDCMD &       // Clock Switching and Monitor (Both Clock Switching and Fail-safe Clock Monitor are disabled)
//    FNOSC_FRCPLL &       // Oscillator Select (Fast RC oscillator with Postscaler and PLL module (FRCPLL))
//    IESO_ON              // Internal External Switch Over Mode (IESO mode (Two-speed start-up) enabled)
//);
int CONFIG1 __attribute__((space(prog), address(0x157FE))) = 0x3F6F;
//_CONFIG1(
//    WDTPS_PS32768 &      // Watchdog Timer Postscaler (1:32,768)
//    FWPSA_PR32 &         // WDT Prescaler (Prescaler ratio of 1:32)
//    WINDIS_OFF &         // Watchdog Timer Window (Standard Watchdog Timer is enabled,(Windowed-mode is disabled))
//    FWDTEN_OFF &         // Watchdog Timer Enable (Watchdog Timer is disabled)
//    ICS_PGx1 &           // Comm Channel Select (Emulator functions are shared with PGEC1/PGED1)
//    GWRP_OFF &           // General Code Segment Write Protect (Writes to program memory are allowed)
//    GCP_OFF &            // General Code Segment Code Protect (Code protection is disabled)
//    JTAGEN_OFF           // JTAG Port Enable (JTAG port is disabled)
//);

// p24fj128ga106.h (C:\Program Files (x86)\Microchip\mplabc30\v3.25\support\PIC24F\h) -  _CONFIG1 _CONFIG2, pic24fj128ga106.pdf
// Fosc = 10MHz*4(PLL) = 40MHz ; Fcy = Fosc/2 = 20MHz
// 10MHz - �� ����������� ������� ������ ���������� 8MHz
// � ������ ��������� ������� Fcy ����������� ��������� ��������� �������� ������:
// 1 Timers - TimerRecalculation.xmcd (Mathcad)
// 2 �������� PR2 �������� �������� �� - SpeedSM.xmcd, SpeedSM.xls
// 3 ��������� ��� �������� ���������� ��������������� ������� ��������� � ������ ������� �������� ������ OC1RS � ����������� �������� ���������� OC1R

unsigned char Reason = NO;

int main() {
    unsigned char i;

    InitPic();

//    _TRISE2 = 0;
//    _LATE2 = 1;
//
//    while (1){
//    }
    
    InitPMSettings();   // �� ��������� ���������� � �� ������������� ������� � ��������!!! ( ������������� ������� ������� ����������� �������� �� PM)

    InitUart();
    InitTimers();       //������������� �������� - �� ��������� ��� ������� Disable � Off
    InitADC();          //������������� ��� - �� ��������� Off

    SetInterruptPriority(); // ��������� ����������� ����������

    InitSM1150();
    SM1150_Set_Power();

    InitUS();

    EnableTimer2();
    InitStepMotor();// ������������� �� ����� �������������� �������� , �.� ��� ������������� �������� ����������� ��������� �� � ������ �������
    EnableTimer3();

    InitStepMotor1();// ������������� �� ����� �������������� �������� , �.� ��� ������������� �������� ����������� ��������� �� � ������ �������
    EnableTimer4();


    InitPneumatics();//����� ������������� �������3 � ���������� ��� ������

    InitPMTSensor();
    OnADC();
    
    EnableUart();
    EnableTimer1(); 
    EnableCnInt();
 
 
    while (1) { 
        if(MainPacketDelay == 0){
           //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
           //�������� ��������� ������           
           //��������� ������ MAX_TX_DATA_SIZE � ������������ � ������������ ������� ������.
            StartTxPacket(0, MAIN_PACKET);
            MoveDataToTxPacket (INT,PMTSensor.HeatingTimerSec);
            MoveDataToTxPacket (INT,PMTSensor.CurLevel);
            MoveDataToTxPacket (INT,SM1150.Power_Level);
            MoveDataToTxPacket (CHAR,SM1150.CurErrorState);
            MoveDataToTxPacket (CHAR,StepMotor.Trailer.Alarm); //������ ��������
            MoveDataToTxPacket (CHAR,Reason);
            
            MoveDataToTxPacket (CHAR,StepMotor.State.Zero);
            MoveDataToTxPacket (CHAR,PMTSensor.HeatingReady);
            MoveDataToTxPacket (CHAR,PMTSensor.State);//? volatile
           
            MoveDataToTxPacket (CHAR,GasExtractSensor.CurErrorState);
            MoveDataToTxPacket (CHAR,GasPlasmaFlowSensor.CurErrorState);
            MoveDataToTxPacket (CHAR,GasPressureSensor.CurErrorState);
            MoveDataToTxPacket (CHAR,GasTransportFlowSensor.CurErrorState);

            MoveDataToTxPacket(INT,StepMotor.Presets.EndPhasePoint[ZERO]);
            MoveDataToTxPacket(INT, StepMotor.Presets.EndPhasePoint[FIRST] - StepMotor.Presets.EndPhasePoint[ZERO]);
            MoveDataToTxPacket(INT, StepMotor.Presets.EndPhasePoint[SECOND] - StepMotor.Presets.EndPhasePoint[FIRST]);
            MoveDataToTxPacket(INT,StepMotor.Presets.EndPhasePoint[THIRD] - StepMotor.Presets.EndPhasePoint[SECOND]);
            MoveDataToTxPacket(INT, StepMotor.Presets.EndPhasePoint[FOURTH] - StepMotor.Presets.EndPhasePoint[THIRD]);

            MoveDataToTxPacket(INT,StepMotor.Presets.PhaseSpeed[ZERO]);
            MoveDataToTxPacket(INT,StepMotor.Presets.PhaseSpeed[FIRST]);
            MoveDataToTxPacket(INT,StepMotor.Presets.PhaseSpeed[SECOND]);
            MoveDataToTxPacket(INT,StepMotor.Presets.PhaseSpeed[THIRD]);
            MoveDataToTxPacket(INT,StepMotor.Presets.PhaseSpeed[FOURTH]);

            MoveDataToTxPacket(CHAR,StepMotor.MovingSettings.Direction);
            MoveDataToTxPacket(INT, StepMotor.State.MovingStepCounter);
            MoveDataToTxPacket(CHAR,StepMotor.MovingSettings.MovingState);
            MoveDataToTxPacket(INT, StepMotor.MovingSettings.Speed);
            MoveDataToTxPacket(LONG,StepMotor.MovingSettings.TargetPosition);
            MoveDataToTxPacket(LONG,StepMotor.State.GeneralStepCounter);
            MoveDataToTxPacket(CHAR,StepMotor.State.WorkMode);

            MoveDataToTxPacket(CHAR,StepMotor.Trailer.Up);
            MoveDataToTxPacket(CHAR,StepMotor.Trailer.Down);

            MoveDataToTxPacket(INT,StepMotor.Presets.TransferCoefficientLV);
            MoveDataToTxPacket(INT,StepMotor.Presets.MaxSpeedOil);
            MoveDataToTxPacket(INT,StepMotor.Presets.ControlVolume);

            MoveDataToTxPacket(INT,StepMotor.DeveloperSettings.TransferCoefficientSL);
            MoveDataToTxPacket(INT,StepMotor.DeveloperSettings.MaxSpeed);
            MoveDataToTxPacket(INT,StepMotor.DeveloperSettings.MaxControlVolume);

            MoveDataToTxPacket (INT,Pneumatics.ValveInTime);
            MoveDataToTxPacket (INT,Pneumatics.ValveOutTime);
            MoveDataToTxPacket (INT,Pneumatics.NumberOfCycles);

            MoveDataToTxPacket (INT,PMTSensor.AverageNumberForPlasmaDetect);
            MoveDataToTxPacket (INT,PMTSensor.DecisionLevel);
            MoveDataToTxPacket (INT,PMTSensor.HeatingTime);
            //MoveDataToTxPacket (INT,PMTSensor.HeatingTimerSec);

            MoveDataToTxPacket (CHAR,SM1150.EnableState);
            MoveDataToTxPacket (CHAR,SM1150.WorkState);
            MoveDataToTxPacket (CHAR,Pneumatics.State);
            MoveDataToTxPacket (CHAR,PMTSensor.State);
            MoveDataToTxPacket (CHAR,PMTSensor.HeatingReady);

            MoveDataToTxPacket (CHAR,GasExtractSensor.CurErrorState);
            MoveDataToTxPacket (CHAR,GasPlasmaFlowSensor.CurErrorState);
            MoveDataToTxPacket (CHAR,GasPressureSensor.CurErrorState);
            MoveDataToTxPacket (CHAR,GasTransportFlowSensor.CurErrorState);

            
            MoveDataToTxPacket (CHAR,StepMotor.State.Block);
            MoveDataToTxPacket (CHAR,US.WorkState);
            MoveDataToTxPacket (CHAR,StepMotor.Trailer.UpBlock);
            MoveDataToTxPacket (CHAR,StepMotor.Trailer.DownBlock);
            MoveDataToTxPacket (CHAR,SM1150.Block);
            MoveDataToTxPacket (CHAR,PMTSensor.Block);   
            MoveDataToTxPacket (CHAR,GasExtractSensor.Block);
            MoveDataToTxPacket (CHAR,GasPlasmaFlowSensor.Block);
            MoveDataToTxPacket (CHAR,GasPressureSensor.Block);
            MoveDataToTxPacket (CHAR,GasTransportFlowSensor.Block);

            i=0;
            while(i<24){
                MoveDataToTxPacket (CHAR,SM1150.Dev_SM1150_Coeff[i]);
                i++;
            }

            MoveDataToTxPacket (INT,StepMotor1.State.GeneralStepCounter);
            MoveDataToTxPacket (INT,StepMotor1.State.MovingStepCounter);
            MoveDataToTxPacket (INT,StepMotor1.State.SavedPosition);
            MoveDataToTxPacket (INT,StepMotor1.MovingSettings.TargetPosition);
            MoveDataToTxPacket (CHAR,StepMotor1.MovingSettings.Direction);
            MoveDataToTxPacket (CHAR,StepMotor1.MovingSettings.MovingState);
            MoveDataToTxPacket (CHAR,StepMotor1.State.ZeroSetMarker);
            MoveDataToTxPacket (CHAR,StepMotor1.State.InSavedPositionMarker);           
            MoveDataToTxPacket (CHAR,StepMotor1.Trailer.State);

            MoveDataToTxPacket (CHAR, FRCFreq);
            MoveDataToTxPacket (CHAR, Version_Major);
            MoveDataToTxPacket (CHAR, Version_Minor);
            MoveDataToTxPacket (CHAR, Version_Build);
            MoveDataToTxPacket (CHAR, Version_Revision);

            EndTxPacket();
            SendTxPaket();
            MainPacketDelay = MAIN_PACKET_DALAY;
        }
        
        AnalyseRxBuffer();//����������� �� ������� ������ � � ������ ��� ����������� �������� ������� RxPacketAnalysis() � ������� ������� ����������� ������ �� ������� ������
        CnReaction();//� ������ ������� ������� ������� ��������� ���������� ���� �������� ������������ ���������� CN // ����������� ������ ������ ����� ������� ReadAndAnalyseRxPackets(), ����� ���������� ���������� ������� ������� � ���������� ������� ������� �������� � ���������� ������������� ���������� ����� ��������������� �������� � ���� �������.
        StepReaction();//
        ADCCannelMeanCount();
        PMTSensorReaction();
        CheckModuleState();
    }
}//END main()
//------------------------------------------------------------------------------

void InitPic(void) {
    //��������� ����������
    CLKDIV = 0x0000; // Kpll = 1:1
    _DOZE = 0; //
    _DOZEN = 0; //
    _VREGS = 0; //
    _ALTIVT = 0; //
    //��������� ���������� ������
    AD1PCFGL =0xFFFF;//��� ���������� ����� ��� ��������
}
//------------------------------------------------------------------------------
void AnalyseRxPacket(void) {//�������� ����������� ���������� ������ - ������ ������� ���������� ��������  ReadAndAnalyseRxPackets() � ������ ����������� ������ (��� ������)
    CommandMemory();
    CommandStepMotor();
    CommandStepMotor1();
    CommandSM1150();
    CommandPneumatics();
    CommandUS();
    PMTSensorCommand();
    GasPressureSensorCommand();
    GasPlasmaFlowSensorCommand();
    GasTransportFlowSensorCommand();
    GasExtractSensorCommand();
    ReasonCommand();

}
void ReasonCommand(void){
    if(Uart.Rx.Packet.Command == RESET_REASON){
        Reason = NO;
    }
}
//------------------------------------------------------------------------------
void CheckModuleState(void){//������� �������������� ������������� ��������� � ������� ������ ��������� ��������� ������ (����� ����������). ��������������� ����� ��������� �� ������� ������������������ ���������� ��������� ������(��������� ����� � ��������� ON) � ���������� �������� ���������� ������� ������ (State = ON) ���� ���������� ��������� ����� ����� ���������� � ��������� ������.
    CheckSM1150WorkState();
    CheckUSWorkState();
    CheckPneumaticsState();
    CheckStepMotorState();
}

void __attribute__((interrupt, no_auto_psv)) _AddressError(void) {
    while(1){
    Putch(0x85);
    Nop();
    Nop();
    Nop();
    Nop();
    Nop();
    VALVE_OUT = 1;}
    //asm("goto %0" : : "r"(USER_PROG_RESET));
}
//------------------------------------------------------------------------------

void __attribute__((interrupt, no_auto_psv)) _StackError(void) {
    while(1){
    Putch(0x86);
    Nop();
    Nop();
    Nop();
    Nop();
    Nop();
    //asm("goto %0" : : "r"(USER_PROG_RESET));
    VALVE_OUT = 1;}

}
//------------------------------------------------------------------------------

void __attribute__((interrupt, no_auto_psv)) _MathError(void) {
    while(1){
    Putch(0x87);
    VALVE_OUT = 1;
    for (;;);}
    //asm("goto %0" : : "r"(USER_PROG_RESET));}

}
//------------------------------------------------------------------------------

void __attribute__((interrupt, no_auto_psv)) _OscillatorFail(void) {
    while(1){
    Putch(0xbb);
    VALVE_OUT = 1;
    for (;;);}
    //asm("goto %0" : : "r"(USER_PROG_RESET));
}
