#ifndef _WAKE_H
#define _WAKE_H

//_____________________________________________________________________________________
//Определение констант
    //Служебные биты протокола Wake - см. документацию Wake протокол передачи данных
    #define FEND    0xC0    //начало пакета
    #define FESC    0xDB    
    #define TFEND   0xDC
    #define TFESC   0xDD
//_____________________________________________________________________________________
//Объявление функций
    void SendWakeTxByte(void); // см. Комментарий - в конце файла
    void StuffingSend(unsigned char byte);
#endif//END #ifndef _WAKE_H 
    

