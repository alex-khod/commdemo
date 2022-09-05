# Communications module demo
[![en](https://img.shields.io/badge/lang-en-green.svg)](README.md)
[![ru](https://img.shields.io/badge/lang-ru-red.svg)](README.ru.md)

This repo hosts communication piece of software for some unnamed device. 
The software itself consists of two parts:
* "Firmware", that runs on device's own microcontroller unit housed on circuit board.
* "Interface", that runs on a PC, visualises device's various systems and also allows to manipulate them by the almighty will of the End User.

Communication module binds these two together via custom reinvented protocol over USB (that imitates a COM port).

Credits: Ivan L., Alexander Kh.