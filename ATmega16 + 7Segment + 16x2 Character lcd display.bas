'======================================================================='

' Title: LCD Display Clock * 2-Digit 7Segment LED
' Last Updated :  04.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : ATmega16 + 7Segment + 16x2 Character lcd display

'======================================================================='

$regfile = "m16def.dat"
$crystal = 4000000

Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = _
Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2

Dim S As Byte , M As Byte , H As Byte , D As Byte , Mm As Byte , Y As Word
Dim Kk As Byte

Config Porta = Output
Config Portb = Output
Config Pind.0 = Output
Config Pind.1 = Output
Config Pind.2 = Output
Config Pind.3 = Output
Config Pind.4 = Output

Cls
Home
Cursor Off
S = 0 : M = 0 : H = 12
Y = 2022 : Mm = 9 : D = 12
Cls : Home : Lcd "time:" : Locate 2 , 1 : Lcd "Date:"
Ddrc.6 = 0 : Portc.6 = 1
Ddrc.7 = 0 : Portc.7 = 1
Ddrd.5 = 0 : Portd.5 = 1
Ddrd.6 = 0 : Portd.6 = 1
Ddrd.7 = 0 : Portd.7 = 1
Declare Sub Incr_h
Declare Sub Incr_m
Declare Sub Day
Declare Sub Month
Declare Sub Year
Config Timer1 = Timer , Prescale = 64
Enable Interrupts
Enable Timer1
Enable Ovf1
Start Timer1
Timer1 = 5180
On Ovf1 _time

'-----------------------------------------------------------

Do
Loop
End

'-----------------------------------------------------------

_time:
If Pinc.6 = 0 Then Call Incr_h
If Pinc.7 = 0 Then Call Incr_m
If Pind.5 = 0 Then Call Day
If Pind.6 = 0 Then Call Month
If Pind.7 = 0 Then Call Year
If S < 10 Then
Kk = Makebcd(s)
Porta = Kk
Locate 1 , 13
Lcd "0" ; S
End If
If M < 10 Then
Kk = Makebcd(m)
Portb = Kk
Locate 1 , 10
Lcd "0" ; M ; ":"
End If
If H < 10 Then
Set Portd.4
If H = 0 Then
Reset Portd.0
Reset Portd.1
Reset Portd.2
Reset Portd.3
End If
If H = 1 Then Set Portd.0
If H = 2 Then
Reset Portd.0
Set Portd.1
End If
If H = 3 Then
Set Portd.0
Set Portd.1
End If
If H = 4 Then
Reset Portd.0
Reset Portd.1
Set Portd.2
End If
If H = 5 Then Set Portd.0
If H = 6 Then
Reset Portd.0
Set Portd.1
End If
If H = 7 Then Set Portd.0
If H = 8 Then
Reset Portd.0
Reset Portd.1
Reset Portd.2
set Portd.3
End If
If H = 9 Then Set Portd.0
Locate 1 , 7
Lcd "0" ; H ; ":"
End If
If S > 9 Then
Kk = Makebcd(s)
Porta = Kk
Locate 1 , 13
Lcd S
End If
If M > 9 Then
Kk = Makebcd(m)
Portb = Kk
Locate 1 , 10
Lcd M ; ":"
End If
If H > 9 Then
Reset Portd.4
If H = 10 Then
Reset Portd.0
Reset Portd.1
Reset Portd.2
Reset Portd.3
End If
If H = 11 Then Set Portd.0
If H = 12 Then
Reset Portd.0
Set Portd.1
End If
If H = 13 Then
Set Portd.0
Set Portd.1
End If
If H = 14 Then
Reset Portd.0
Reset Portd.1
Set Portd.2
End If
If H = 15 Then Set Portd.0
If H = 16 Then
Reset Portd.0
Set Portd.1
End If
If H = 17 Then Set Portd.0
If H = 18 Then
Reset Portd.0
Reset Portd.1
Reset Portd.2
set Portd.3
End If
If H = 19 Then Set Portd.0
Locate 1 , 7
Lcd H ; ":"
End If
If D < 10 Then
Locate 2 , 15
Lcd "0" ; D
End If
If Mm < 10 Then
Locate 2 , 12
Lcd "0" ; Mm ; "/"
End If
If D > 9 Then
Locate 2 , 15
Lcd D
End If
If Mm > 9 Then
Locate 2 , 12
Lcd Mm ; "/"
End If
Locate 2 , 7
Lcd Y ; "/"
Incr S
If S > 59 Then
S = 0
Incr M
If M = 60 Then
M = 0
Incr H
If H = 24 Then
H = 0
Incr D
If Mm < 7 Then
If D > 31 Then
D = 1
Incr Mm
End If
End If
If Mm > 6 Then
If D > 30 Then
D = 1
Incr Mm
End If
End If
If Mm > 12 Then
Mm = 1
Incr Y
End If
End If
End If
End If
Timer1 = 5180
Return

''''''''''''''''''''''''''''''

Incr_h:
H = H + 1
If H > 23 Then H = 0
Return

''''''''''''''''''''''''''''''

Incr_m:
M = M + 1
If M > 59 Then M = 0
Return

''''''''''''''''''''''''''''''

Day:
If Mm < 7 Then
D = D + 1
If D > 31 Then
D = 1
End If
End If
If Mm > 6 Then
D = D + 1
If D > 30 Then
D = 1
End If
End If
Return

''''''''''''''''''''''''''''''

Month:
Mm = Mm + 1
If Mm > 12 Then Mm = 1
Return

''''''''''''''''''''''''''''''

Year:
Y = Y + 1
Return

'-----------------------------------------------------------