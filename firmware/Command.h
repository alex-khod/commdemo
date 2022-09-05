#ifndef _COMMAND_H
#define _COMMAND_H

    //_____________________________________________________________________________________
    //����������� �������

    //������� ��������� ����������
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
     #define RESET_REASON                                     0x50
     
    //������� ��
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    #define SM_WRITE_DEV_SETTINGS                               0x00//�������� ��������� ������������ (��� ��)
    #define SM_SET_PRESETS_ADDITIONAL                           0x01//���������� �������������� ������� ��������� (��� ��)
    #define SM_SET_PRESETS_PHASE                                0x02//���������� ������� ��������� ��� ������� (��� ��)
    #define SM_WRITE_PRESETS_AS_DEFAULT                         0x03//�������� �������������� ������� ��������� (��� ��)��� �������������� ��������� �� ���������
    #define SM_LOAD_DEFAULT_TO_PRESETS                          0x04//
    #define SM_SET_DOWN_TRAILER_BLOCK                           0x32//
    #define SM_SET_UP_TRAILER_BLOCK                             0x31//
    #define SM_SET_BLOCK                                        0x33//

    #define SM_SET_ZERO                 0x05//���������� ���� � ������ ������� (��� ��)
    #define SM_SET_WORK_MODE            0x06//������� � ������� ����� (��� ��)
    #define SM_COLIBRATE_DONE           0x07
    #define SM_COLIBRATE_NOT_DONE       0x08
    #define SM_STOP                     0x09//���������� �� (��� ��)
    #define SM_RETURN                   0x0A//��������� ������� �� (��� ��)
    #define SM_START_PHASES             0x0B//������ �������� � ������������ � ���������� ������� (��� ��)
    #define SM_MOVE_BACK                0x0C//����������� �� ����� (��� ��)
    #define SM_MOVE_FORWARD             0x0D//����������� �� ������ (��� ��)
    #define SM_WASHING                  0x0E//�������� (��� ��)
    #define SM_RESET_ALARM              0x0F

    #define SM1_DETERMINATE_POSITION                0x38
    #define SM1_SAVE_POSITION                       0x39
    #define SM1_MOVE_FORWARD                        0x3A
    #define SM1_MOVE_BACK                           0x3B
    #define SM1_STOP                                0x3C
    #define SM1_MOVE_TO_SAVED_POSITION              0x3D

    //������� SM1150
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    #define SM1150_ENABLE_DISABLE               0x2A
    #define SM1150_ON                           0x23//������/���������� ������ �������� � �������� (��� SM1150)
    #define SM1150_SET_POWER                    0x24//���������� ������� �������� ���������� � �������� (��� SM1150)
    #define SM1150_SET_COEFF                    0x37
    #define SM1150_OFF                          0x20
    //������� �������������� ������
    //_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    #define PNEUMATICS_SET_SETTINGS           0x22//���������� ��������� (��� ��������������� �������)
    #define PNEUMATICS_SET_FIRE               0x21//��������� ������� ������� ������

    #define PMT_SENSOR_SET_BLOCK              0x2B
    #define PMT_SENSOR_SET_DECISION_LEVEL     0x25
    #define PMT_SET_HEARTING_TIME             0x26
    #define PMT_STOP_HEARTING                 0x27
    #define PMT_SENSOR_SET_AVERAGE_NUMBER     0x30

    #define SAVE_FIRE_SETTINGS                0x28
    #define LOAD_FIRE_SETTINGS                0x29

    #define GAS_PRESSURE_SENSOR_SET_BLOCK          0x2E
    #define GAS_PLASMA_FLOW_SENSOR_SET_BLOCK       0x2D
    #define GAS_TRANSPORT_FLOW_SENSOR_SET_BLOCK    0x2F
    #define GAS_EXTRACT_SENSOR_SET_BLOCK           0x2C

    #define US_ON_OFF                              0x34
    #define EXPORT_PACKET                          0x35
    #define IMPORT_PACKET                          0x36
    //_____________________________________________________________________________________
    //������������ �������
    //��� ������������� ��������� Wake ��� ������� �������� 7 !!! ���, ��� ���������  ���������� �� 128 ��������� ������.(127=0x7F - ��������� �������� �������)
    #define MAIN_PACKET                         0x70
    
#endif //END #ifndef _COMMAND_H

