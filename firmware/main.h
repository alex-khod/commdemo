#ifndef _MAIN_H        
#define _MAIN_H 

#include <p24Fxxxx.h>
#include <p24fj128ga106.h>
#include <libpic30.h>

#include "Command.h"
#include "version.h"

#if !defined(__PACKED)
        #define __PACKED
#endif

#define Version_Major 2
#define Version_Minor 2
#define Version_Build 1
#define Version_Revision 0

#define	FCY	2 * FRCFreq * 1e6  //тактова€ частота
//_____________________________________________________________________________________
//  ќбъ€вление "глобальных" констант 

#define ON              1
#define OFF             0

#define DET             1
#define NOT_DET		0

#define YES             1
#define NO		0

#define ENABLE_STATE    1
#define DISABLE_STATE   0

#define START           1 //начало процесса
#define STOP            0 //конец процесса, процесс не активен, процесс закончен
#define WAIT            2 //ожидание

#define DEFAULT         0

#define ADJUST          1
#define STANDART        2

#define ADJUST1         1
#define STANDART1       2

#define NORMAL   	1
#define NORMAL_SM1150   0
#define ALARM     	0

#define ALARM_LOW	2
//#define LOW   		2
//#define HIGH	 	3
#define ALARM_HIGH 	0
#define ERROR           6

//константы причины произошедшего событи€(в случае возникновени€ тревоги).»спользуютс€ в функци€х реакции на тревогу присваиваютс€ переменной Reason
#define SM1150_ALARM                        1
#define GAS_PRESSURE_SENSOR_ALARM           2
#define GAS_PLASMA_FLOW_SENSOR_ALARM        3
#define GAS_TRANSPORT_FLOW_SENSOR_ALARM     4
#define GAS_EXTRACT_SENSOR_ALARM            5
#define PMT_SENSOR_OFF                      6

//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
// ќбъ€вление переменных
extern unsigned char Reason;//переменна€ отслеживающа€ тревогу котора€ привела к отклонению процесса анализа от стандартного протекани€ (тревога по причине которой остановилс€ анализ)
//_____________________________________________________________________________________
//  ќбъ€вление функций
void InitPic(void);
void AnalyseRxPacket(void);//функци€ анализа обнаруженного прин€того пакета
void ReasonCommand(void);//
void CheckModuleState(void);
void __attribute__((interrupt, no_auto_psv)) _AddressError (void);
void __attribute__((interrupt, no_auto_psv)) _StackError (void);
void __attribute__((interrupt, no_auto_psv)) _MathError (void);
void __attribute__((interrupt, no_auto_psv)) _OscillatorFail (void);

#endif //END #ifndef _MAIN_H


