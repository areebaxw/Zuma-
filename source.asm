
include Irvine32.inc

include Macros.inc
includelib Winmm.lib



PlaySound PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD

ExitProcess PROTO, a1:DWORD

.386
.model flat,stdcall
.stack 4096

.data
   
    prompt1 db "Enter your name:", 0
    menuSelect db 1
    POINTER DB ' <<<<<<<<<<<<<<<<   ', 13, 10, 0
  
   currentLevel db 1
    path1 db '------------------------------------------------------------------------------------------------', 0
    path2 db '|', 0
    counter db ?
    counter1 db ?
    path3 db '-----------------------------------------------------------------------------------------', 0
    directionFlag BYTE 0
    frogX BYTE 63            
    frogY BYTE 10               
    projX BYTE 0                
    projY BYTE 0                 
    isShooting BYTE 0            
    frogSymbol BYTE 'F', 0       
    projectileSymbol BYTE '0', 0 
    facedir BYTE 'U'     
    ballUpdateCounter BYTE ?    
    myname db ?



    str1 db "                       _           _            ", 0
str2 db "                      / \_______ /|_\            ", 0
str3 db "                     /          /_/ \__          ", 0
str4 db "                    /             \_/ /          ", 0
str5 db "                  _|_              |/|_          ", 0
str6 db "                  _|_  O    _    O  _|_          ", 0
str7 db "                  _|_      (_)      _|_          ", 0
str8 db "                   \                 /           ", 0
str9 db "                    _\_____________/_           ", 0
str10 db "                   /  \/  (___)  \/  \          ", 0
str11 db "                   \__(  o     o  )__/          ", 0


filename db "output.txt", 0
    filehandle dd 0
    reader db 255 dup(?)
    player db 255 dup(?)
    nameLength db 0
    filelength db 0
    poorilength db 0
    score dword 0
   scstr db 12 dup(0)




     numBalls     db 20              
    maxBalls     db 100             
  
    ballSymbol   db 'O',0            
    emptySymbol  db ' ' ,0           

    ballChainX   db 100 dup(0)     
    ballChainY   db 100 dup(0)       
   ballColors db 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0,50 dup (0)
  
  scorehaha db "Score:",0
;  score dword ?




  output_filename db "tired.txt",0


 ZUMBA_sketch db '                                                                   ', 13, 10
                db '                       ______       __  __       __    __       ______      ______    ', 13, 10
                db '                      /\___  \     /\ \/ \ \    /\ "-./  \     /\  == \    /\  __ \   ', 13, 10
                db '                      \/_/  /__    \ \ \_\ \    \ \ \-./\ \    \ \  __<    \ \  __ \  ', 13, 10
                db '                        /\_____\    \ \_____\    \ \_\ \ \_\    \ \_____\   \ \_\ \_\ ', 13, 10
                db '                        \/_____/     \/_____/     \/_/  \/_/     \/_____/    \/_/\/_/ ', 13, 10
                db 0
    ZUMA_INSTRUCTIONS_SCREEN db 'Controls:                                                                                        ', 13, 10
                            db '                                                                                                 ', 13, 10
                            db ' 1-Use the (w a s d q e z c) to aim the shooter.                                              ', 13, 10
                            db ' 2-Press space to shoot the ball at the matching colored balls in the chain.                        ', 13, 10
                            db '                                                                                                 ', 13, 10
                            db 'Gameplay:  ',13,10
                            db '              ',13, 10
                            db ' 1-Shoot balls to match 3 or more balls of the same color to eliminate them from the chain.        ', 13, 10
                            db ' 2-Eliminate all balls in the chain before they reach the end of the path.',13,10 
                            db  ' 3-Total balls that can be thrown during level 1 ',13,10
                            db  '  are 10 and level 2 are 5',13,10
                            db ' 4- if you score 25 then u proceed towards Level 2',13,10
                            db '                                              ',13,10
                            db '                                   ',13,10
                            db 'Press P to start game', 13, 10
                            db 0
    START DB '                                          ___ ___ ___ ___ ___   ', 13, 10
              DB '                                              / __|_ _| . | . |_ _|  ', 13, 10
              DB '                                              \__ \| ||   |   /| |   ', 13, 10
              DB '                                              <___/|_||_|_|_\_\|_|   ', 13, 10
              DB 0
  
  ballsThrown db 0     

    ;ballColors1 db 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 1, 1, 1, 2, 2, 2, 2,50 dup (0)
maxBalls1 db 20  

daba db '------------',0
daba1 db '|',0
   
billi1 db  '   /\_/\  ',0
 billi2  db  '  ( o.o ) ',0
 billi3     db  '   > ^ <  ',0
 
  gamePaused BYTE 0   
    pauseMessage DB 'Game Paused. Press ''p'' to Resume.', 0




kitty1 db " ,        _  _      ", 0
kitty2 db "/|   |   | || |     ", 0
kitty3 db " |___| _ | || | __  ", 0
kitty4 db " |   ||/ |/ |/ /  \_", 0
kitty5 db " |   ||__|__|__\__/ ", 0
kitty6 db " ,                  ", 0
kitty7 db "/|   /o             ", 0
kitty8 db " |__/  _|_|_        ", 0
kitty9 db " | \  | | |  |   |  ", 0
kitty10 db " |  \_|_|_|_/ \_/|/ ", 0
kitty11 db "                /|  ", 0
kitty12 db "                \|  ", 0








  

      name1 db 255 dup(0)
    


file BYTE "zumba.wav",0

SND_ALIAS    DWORD 00010000h
SND_FILENAME DWORD 00020000h
SND_ASYNC    DWORD 00000001h



.code



main PROC
  

  
    INVOKE PlaySound, OFFSET file, NULL,SND_ASYNC
  ;invoke ExitProcess, 0
 
        call start1

    ret
main ENDP


mainGameLogicLevel1 PROC
    
    mov ecx, 0
    mov cl, numBalls
    mov esi, OFFSET ballChainX
    mov edi, OFFSET ballChainY

inlevel1:
    mov BYTE PTR [esi], 100
    mov BYTE PTR [edi], 2
    inc esi
    inc edi
    loop inlevel1

    call clrscr
    call game1
    call DrawFrog

gameLoopLevel1:
    call ReadUserInput

    cmp gamePaused, 1
    je displayPauseScreenLevel1

    call MoveProjectile
    call DrawFrog

    inc ballUpdateCounter
    cmp ballUpdateCounter, 50
    jl skipBallUpdateLevel1

    mov ballUpdateCounter, 0
    call UpdateBallChain

   



    cmp score, 25
    je startLevel2


skipBallUpdateLevel1:
    mov ecx,999999
delayLoopLevel1:
    loop delayLoopLevel1

    jmp gameLoopLevel1

displayPauseScreenLevel1:
    mov dl, 12
    mov dh, 21
    call gotoxy
    mov eax, lightcyan
    call settextcolor
    mov edx, OFFSET pauseMessage
    call writestring

pauseWaitLevel1:
    call ReadUserInput
    cmp gamePaused, 1
    je pauseWaitLevel1

    mov dl, 12
    mov dh, 21
    call gotoxy
    mov eax, black
    call settextcolor
    mov edx, OFFSET pauseMessage
    call writestring
    jmp gameLoopLevel1

mainGameLogicLevel1 ENDP


mainGameLogicLevel2 PROC

    mov ecx, 0
    mov cl,20
    mov esi, OFFSET ballChainX
    mov edi, OFFSET ballChainY

initLoopLevel2:
    mov BYTE PTR [esi], 100
    mov BYTE PTR [edi], 2
    inc esi
    inc edi
    loop initLoopLevel2

    call clrscr
    call game1
    call DrawFrog

gameLoopLevel2:
    call ReadUserInput

    cmp gamePaused, 1
    je displayPauseScreenLevel2

    call MoveProjectile
    call DrawFrog

    inc ballUpdateCounter
    cmp ballUpdateCounter, 50
    jl skipBallUpdateLevel2

    mov ballUpdateCounter, 0
    call UpdateBallChain

skipBallUpdateLevel2:
    mov ecx,984999
delayLoopLevel2:
    loop delayLoopLevel2

    jmp gameLoopLevel2

displayPauseScreenLevel2:
    mov dl, 12
    mov dh, 21
    call gotoxy
    mov eax, lightcyan
    call settextcolor
    mov edx, OFFSET pauseMessage
    call writestring

pauseWaitLevel2:
    call ReadUserInput
    cmp gamePaused, 1
    je pauseWaitLevel2

    mov dl, 12
    mov dh, 21
    call gotoxy
    mov eax, black
    call settextcolor
    mov edx, OFFSET pauseMessage
    call writestring
    jmp gameLoopLevel2

mainGameLogicLevel2 ENDP

startLevel2 PROC
    call clrscr
    call crlf
    mov eax,lightmagenta
    call settextcolor
    call crlf
    call crlf
    call crlf
    mwrite "Congrats, you have passed Level 1 with 25 score",0
    call crlf
    call crlf
      mwrite "Level 2: Get Ready buck up buck up buck up!"
      call crlf
      call crlf
    call waitmsg

    mov dl, 20
    mov dh, 20
    call gotoxy
    mov eax, yellow
    call settextcolor


    mov ecx, 200000
delayLoopLevel2Start:
    loop delayLoopLevel2Start

    mov currentLevel, 2
    mov ballsThrown, 0
    mov score,0
    mov directionFlag, 0
    mov ballUpdateCounter, 0

    
    
   
    mov esi, OFFSET ballColors
    mov ecx, 0
    mov numBalls,20
    mov cl, numBalls
initLevel2Colors:
    mov eax, 4
    call randomrange
    mov al, al
    mov [esi], al
    inc esi
    loop initLevel2Colors
    

    call mainGameLogicLevel2
    ret
startLevel2 ENDP

start1 PROC


    mov dl, 50
    mov dh, 10
    mov eax, lightmagenta
    call settextcolor
    call gotoxy
    mov edx, OFFSET ZUMBA_sketch
    call writestring


    
    mgotoxy 32,17
    mov eax,yellow
    call settextcolor
    mwrite "I, Areeba Waqar Welcome yall to my COAL project"
    call crlf
    mov eax, yellow
    call settextcolor
    mov dh, 0
    mov dl, 0
    call gotoxy
    mov edx, OFFSET prompt1
    call writestring
    mreadstring name1
    mov myname, al

menuLoop:
    call clrscr
    mov dl, 5
    mov dh, 5
    call gotoxy
    mov eax, yellow
    call settextcolor
    mov edx, OFFSET START
    call writestring

    mov dl, 8
    mov dh, 10
    call gotoxy
    mov eax, lightmagenta
    call settextcolor
    mov edx, OFFSET ZUMA_INSTRUCTIONS_SCREEN
    call writestring

    call readchar
    cmp al, 'P'
    je startGame
    cmp al, '2'
    je showInstructions
    cmp al, '3'
    je exitGame

    jmp menuLoop

startGame:
    call clrscr
    mov numBalls, 20
    mov currentLevel, 1
    call mainGameLogicLevel1
    ret

showInstructions:
    call clrscr
    mov dl, 0
    mov dh, 0
    call gotoxy
    mov edx, OFFSET ZUMA_INSTRUCTIONS_SCREEN
    call writestring
    call readchar
    call clrscr
    jmp menuLoop

exitGame:
    ret
start1 ENDP


scorehehe PROC

    mov al, currentLevel
    cmp al, 1
    je level1Score
    cmp al, 2
    je level2Score

level1Score:
    mov eax, score              
    add eax, 5                  
    mov score, eax              
    jmp displayScore

level2Score:
mov score,0
    mov eax, score              
    add eax, 3                  
    mov score, eax              

displayScore:
    mov dl, 8                 
    mov dh, 1                  
    call gotoxy
    mov eax, lightcyan           
    call settextcolor
    mov eax, score              
    call writedec

    ret
scorehehe endp

game1 PROC



mov eax, lightmagenta   
        call settextcolor
        mov edx, offset str1
		mgotoxy 35,4

        call writestring
        mov edx, offset str2
        mgotoxy 35, 5

		call writestring
        mov edx, offset str3
        mgotoxy 35, 6

        call writestring    
        mov edx, offset str4
        mgotoxy 35, 7

        call writestring    
        mov edx, offset str5
	    mgotoxy 35, 8

        call writestring
        mov edx, offset str6
	    mgotoxy 35, 9

        call writestring
        mov edx, offset str7
	    mgotoxy 35, 10

        call writestring
        mov edx, offset str8
	    mgotoxy 35, 11

        call writestring
        mov edx, offset str9
	    mgotoxy 35, 12

        call writestring
        mov edx, offset str10
	    mgotoxy 35, 13

        call writestring
        mov edx, offset str11
	    mgotoxy 35, 14

        call writestring

        mov eax,yellow
           call settextcolor
        mov edx, offset kitty1
		mgotoxy 85,4
        call writestring
        mov edx, offset kitty2
        mgotoxy 85, 5
		call writestring
        mov edx, offset kitty3
        mgotoxy 85, 6
        call writestring    
        mov edx, offset kitty4
        mgotoxy 85, 7
        call writestring    
        mov edx, offset kitty5
	    mgotoxy 85, 8

        call writestring
        mov edx, offset kitty6
	    mgotoxy 85, 9

        call writestring
        mov edx, offset kitty7
	    mgotoxy 85, 10
        call writestring
        mov edx, offset kitty8
	    mgotoxy 85, 11
        call writestring
        mov edx, offset kitty9
	    mgotoxy 85, 12
        call writestring
        mov edx, offset kitty10
	    mgotoxy 85, 13
        call writestring
        mov edx, offset kitty11
	    mgotoxy 85, 14
        call writestring
      mov edx, offset kitty12
	    mgotoxy 85, 15
        call writestring
     








mov eax,0
 mov al, currentLevel           
    cmp eax, 1                     
    je displayLevel1 

    cmp eax, 2                      
    je displayLevel2             

    displayLevel1:

    mov dl,1
    mov dh,10
    call gotoxy
    mov eax,(lightmagenta+white*16)
    call settextcolor
    mwrite "Level:1",0
    jmp exit1
    


    displayLevel2:
    mov dl,1
    mov dh,10
    call gotoxy
     mov eax,(yellow+lightgreen*16)
    call settextcolor
    mwrite "Level:2",0

    exit1:



  
     mov dl,111
    mov dh,17
     call gotoxy
     mov eax,red
    call settextcolor
   
    mov edx,offset billi1
    call writestring

        mov dl,111
    mov dh,18
     call gotoxy
     mov eax,red
    call settextcolor
   
    mov edx,offset billi2
    call writestring

       mov dl,111
    mov dh,19
     call gotoxy
     mov eax,red
    call settextcolor
   
    mov edx,offset billi3
    call writestring

     





    mov edx,0
     mov dl,1
    mov dh,1
     mov eax,lightcyan
    call settextcolor
    call gotoxy
    mov edx,offset scorehaha
    call writestring
    
    mov dl, 14
    mov dh, 1
    mov eax, lightmagenta
    call settextcolor
    call gotoxy
    mov edx, OFFSET path1
    call writestring

    mov dl, 19
    mov dh, 3
    mov eax, yellow
    call settextcolor
    call gotoxy
    mov edx, OFFSET path3
    call writestring

    mov edx, 0
    mov ecx, 18
    mov counter, 14
    mov counter1, 2
l1:
    mov dl, counter
    mov dh, counter1
    mov eax, lightmagenta
    call settextcolor
    call gotoxy
    mov edx, OFFSET path2
    call writestring
    mov counter, 14
    inc counter1
    loop l1

    mov edx, 0
    mov ecx, 14
    mov counter, 18
    mov counter1, 4
l2:
    mov dl, counter
    mov dh, counter1
    mov eax, yellow
    call settextcolor
    call gotoxy
    mov edx, OFFSET path2
    call writestring
    mov counter, 18
    inc counter1
    loop l2

    mov edx, 0
    mov dl, 18
    mov dh, 17
    mov eax, yellow
    call settextcolor
    call gotoxy
    mov edx, OFFSET path1
    call writestring

    mov edx, 0
    mov dl, 15
    mov dh, 19
    mov eax, lightmagenta
    call settextcolor
    call gotoxy
    mov edx, OFFSET path1
    call writestring
    ret

    ret
game1 ENDP



UpdateBallChain PROC
    mov ecx, 0
    mov cl, numBalls
    mov esi, OFFSET ballChainX
    mov edi, OFFSET ballChainY

clearLoop:
    mov dl, [esi]
    mov dh, [edi]
    call gotoxy
    mov al, emptySymbol
    call writechar
    inc esi
    inc edi
    loop clearLoop

    mov al, directionFlag
    cmp al, 0
    je moveLeft
    cmp al, 1
    je moveDown
    cmp al, 2
    je moveRight

moveLeft:
    mov ecx, 0
    mov cl, numBalls
    dec ecx

moveLeftLoop:
    mov esi, OFFSET ballChainX
    add esi, ecx
    mov edi, OFFSET ballChainY
    add edi, ecx
    mov al, [esi - 1]
    mov [esi], al
    mov al, [edi - 1]
    mov [edi], al
    loop moveLeftLoop

    mov esi, OFFSET ballChainX
    dec BYTE PTR [esi]
    cmp BYTE PTR [esi], 16
    jle switchToDown
    jmp drawBallChain

moveDown:
    mov ecx, 0
    mov cl, numBalls
    dec ecx

moveDownLoop:
    mov esi, OFFSET ballChainX
    add esi, ecx
    mov edi, OFFSET ballChainY
    add edi, ecx
    mov al, [esi - 1]
    mov [esi], al
    mov al, [edi - 1]
    mov [edi], al
    loop moveDownLoop

    mov esi, OFFSET ballChainY
    inc BYTE PTR [esi]
    cmp BYTE PTR [esi], 18
    jge switchToRight
    jmp drawBallChain

moveRight:
    mov ecx, 0
    mov cl, numBalls
    dec ecx

moveRightLoop:
    mov esi, OFFSET ballChainX
    add esi, ecx
    mov edi, OFFSET ballChainY
    add edi, ecx
    mov al, [esi - 1]
    mov [esi], al
    mov al, [edi - 1]
    mov [edi], al
    loop moveRightLoop

    mov esi, OFFSET ballChainX
    inc BYTE PTR [esi]
    cmp BYTE PTR [esi], 118
    jl drawBallChain

    call fileOps
    jmp clearScreen

switchToDown:
    mov directionFlag, 1
    jmp drawBallChain

switchToRight:
    mov directionFlag, 2
    jmp drawBallChain

drawBallChain:
    mov ecx, 0
    mov cl, numBalls
    mov esi, OFFSET ballChainX
    mov edi, OFFSET ballChainY
    mov ebx, OFFSET ballColors

drawLoop:
    cmp ecx, 0
    jle exitGame

    mov dl, [esi]
    mov dh, [edi]
    call gotoxy

    mov al, [ebx]
    cmp currentLevel, 2

    je drawLevel2Colors

    cmp al, 0
    je setColorBlue
    cmp al, 1
    je setColorRed
    cmp al, 2
    je setColorGreen
    cmp al, 3
    je setColorMagenta

drawLevel2Colors:

    cmp al, 0
    je setColorCyan
    cmp al, 1
    je setColorYellow
    cmp al, 2
    je setColorWhite
    cmp al, 3
    je setColorGray


setColorBlue:
    mov eax, blue
    call settextcolor
    jmp drawBall

setColorRed:
    mov eax, red
    call settextcolor
    jmp drawBall

setColorGreen:
    mov eax, green
    call settextcolor
    jmp drawBall

setColorMagenta:
    mov eax, magenta
    call settextcolor
    jmp drawBall

setColorCyan:
    mov eax, cyan
    call settextcolor
    jmp drawBall

setColorYellow:
    mov eax, yellow
    call settextcolor
    jmp drawBall

setColorWhite:
    mov eax, white
    call settextcolor
    jmp drawBall

setColorGray:
    mov eax, gray
    call settextcolor
    jmp drawBall

drawBall:
    mov al, ballSymbol
    call writechar

    inc esi
    inc edi
    inc ebx
    dec ecx
    jmp drawLoop

stopMovement:
  writef:

    mov dl, [esi]
    cmp dl, 78
    jge clearScreen

    ret

clearScreen:
   call clrscr
    call clrscr
    call crlf
    call crlf
    mov eax,lightmagenta
    call settextcolor
    mwrite "Awe, Sorry you have lost :("
   call crlf
   call crlf
    exit

exitGame:
    ret

fileOps PROC
    mov edx, offset filename
    mov eax, filehandle
    call openinputfile
    mov filehandle, eax
    jc fileOpenError
    
    mov edx, offset reader
    mov ecx, lengthof reader
    call readFromFile
    jc fileReadError
    mov filelength, al
    mov eax, filehandle
    call closeFile
    mov al, filelength
    mov poorilength, al

    push esi
    mov esi, offset reader
    movzx edx, filelength
    add esi, edx
    mov al, 13d
    mov [esi], al
    inc esi
    mov al, 10d
    mov [esi], al
    inc esi

    push ecx
    movzx ecx, myname
    mov edi, offset name1
    mov al, myname
    add poorilength, al

AppendName:
    mov al, [edi]
    mov [esi], al
    inc esi
    inc edi
    loop AppendName
    add poorilength, 2
    mov al, ' '
    mov [esi], al
    inc esi
    pop ecx

    push eax
    push ebx
    push edx
    push edi

    mov eax, score
    mov edi, OFFSET scstr
    mov ecx, 0
    mov ebx, 10

ConvertScoreLoop:
    mov edx, 0
    div ebx
    add dl, '0'
    push dx
    inc ecx
    test eax, eax
    jnz ConvertScoreLoop

StoreScoreLoop:
    pop dx
    mov [edi], dl
    inc edi
    loop StoreScoreLoop

    mov byte ptr [edi], 0

    mov ecx, lengthof scstr
    add poorilength, 12
    mov edi, offset scstr

AppendScore:
    mov al, [edi]
    mov [esi], al
    inc esi
    inc edi
    loop AppendScore

    pop edi
    pop edx
    pop ebx
    pop eax

    push eax
    push edx

    mov eax, filehandle
    mov edx, offset filename
    call createoutputFile
    mov filehandle, eax
    mov edx, offset reader
    movzx ecx, poorilength
    call writeToFile
    jc fileWriteError
    mov eax, filehandle
    call closeFile

    pop edx
    pop eax

    jmp fileSuccess

fileOpenError:
    mwrite "Cannot open"
fileReadError:
    mwrite "Cannot read"
fileWriteError:
    mwrite "Cannot write"
fileSuccess:
    mwrite "Success"
fileOps ENDP



UpdateBallChain ENDP




DrawFrog PROC
   
    mov dl, frogX
    mov dh, frogY
    call gotoxy
    mov eax, yellow
    call settextcolor

    cmp facedir, 'U'
    je drawUp

    cmp facedir, 'D'
    je drawDown

    cmp facedir, 'L'
    je drawLeft

    cmp facedir, 'R'
    je drawRight

    cmp facedir, 'Q'
    je drawUpLeft

    cmp facedir, 'E'
    je drawUpRight

    cmp facedir, 'Z'
    je drawDownLeft

    cmp facedir, 'C'
    je drawDownRight

drawUp:
    mov al, '^'
    call writechar
    ret

drawDown:
    mov al, 'v'
    call writechar
    ret

drawLeft:
    mov al, '<'
    call writechar
    ret

drawRight:
    mov al, '>'
    call writechar
    ret

drawUpLeft:
    mov al, '\'
    call writechar
    ret

drawUpRight:
    mov al, '/'
    call writechar
    ret

drawDownLeft:
    mov al, '/'
    call writechar
    ret

drawDownRight:
    mov al, '\'
    call writechar
    ret
DrawFrog ENDP

ReadUserInput PROC
    call ReadKey                

    cmp al, 'p'               
    je togglePause
    cmp al, 'r'                 
    je togglePause

    cmp al, ' '
    je shootProjectile
    cmp al, 'w'
    je faceUp
    cmp al, 's'
    je faceDown
    cmp al, 'a'
    je faceLeft
    cmp al, 'd'
    je faceRight
    cmp al, 'q'
    je faceUpLeft
    cmp al, 'e'
    je faceUpRight
    cmp al, 'z'
    je faceDownLeft
    cmp al, 'c'
    je faceDownRight
    ret

togglePause:
    xor gamePaused, 1         
    ret




endInput:
    ret

  

shootProjectile:
    cmp isShooting, 1
    je endInput

    mov al, frogX
    mov projX, al
    mov al, frogY
    mov projY, al
    mov isShooting, 1
    ret

faceUp:
    mov facedir, 'U'
    ret

faceDown:
    mov facedir, 'D'
    ret

faceLeft:
    mov facedir, 'L'
    ret

faceRight:
    mov facedir, 'R'
    ret

faceUpLeft:
    mov facedir, 'Q'
    ret

faceUpRight:
    mov facedir, 'E'
    ret

faceDownLeft:
    mov facedir, 'Z'
    ret

faceDownRight:
    mov facedir, 'C'
    ret
ReadUserInput ENDP

MoveProjectile PROC

   cmp isShooting, 0
    je endMoveProjectile

   
    mov al, currentLevel
    cmp al, 1         
    je level1Limit
    cmp al, 2         
    je level2Limit

level1Limit:
    cmp ballsThrown, 10
    jge stopShooting
    jmp continue

level2Limit:
    cmp ballsThrown, 5   
    jge stopShooting
    jmp continue



    continue:

    mov dl, projX
    mov dh, projY
    call gotoxy
    mov al, emptySymbol
    call writechar

    cmp facedir, 'U'
    je moveProjectileUp
    cmp facedir, 'D'
    je moveProjectileDown
    cmp facedir, 'L'
    je moveProjectileLeft
    cmp facedir, 'R'
    je movprojright
    cmp facedir, 'Q'
    je moveProjectileUpLeft
    cmp facedir, 'E'
    je moveProjectileUpRight
    cmp facedir, 'Z'
    je moveProjectileDownLeft
    cmp facedir, 'C'
    je moveProjectileDownRight

moveProjectileUp:
    cmp projY, 1
    jle stopShooting
    dec projY
    jmp checkCollision

moveProjectileDown:
    cmp projY, 25
    jge stopShooting
    inc projY
    jmp checkCollision

moveProjectileLeft:
    cmp projX, 1
    jle stopShooting
    dec projX
    jmp checkCollision

movprojright:
    cmp projX, 78
    jge stopShooting
    inc projX
    jmp checkCollision

moveProjectileUpLeft:
    cmp projX, 1
    jle stopShooting
    dec projX
    cmp projY, 1
    jle stopShooting
    dec projY
    jmp checkCollision

moveProjectileUpRight:
    cmp projX, 78
    jge stopShooting
    inc projX
    cmp projY, 1
    jle stopShooting
    dec projY
    jmp checkCollision

moveProjectileDownLeft:
    cmp projX, 1
    jle stopShooting
    dec projX
    cmp projY, 25
    jge stopShooting
    inc projY
    jmp checkCollision

moveProjectileDownRight:
    cmp projX, 78
    jge stopShooting
    inc projX
    cmp projY, 25
    jge stopShooting
    inc projY
    jmp checkCollision

checkCollision:
    mov ecx, 0
    mov cl, numBalls
    mov esi, OFFSET ballChainX
    mov edi, OFFSET ballChainY

collisionCheckLoop:
    cmp ecx, 0
    jle noCollision

    mov al, [esi]
    cmp al, projX
    jne nextBall
    mov al, [edi]
    cmp al, projY
    jne nextBall

    inc numBalls
    inc ecx

    mov al, currentLevel
    cmp al, 1
    je level1Colors

    cmp al, 2
    je level2Colors

level1Colors:
    mov eax, 4
    call randomrange

    movzx eax, al
    mov dl, 40
    mov dh, 10
    call gotoxy

    cmp al, 0
    je printBlue
    cmp al, 1
    je printRed
    cmp al, 2
    je printGreen
    cmp al, 3
    je printMagenta

    jmp printDone

level2Colors:

    mov eax, 4
    call randomrange

    movzx eax, al
    mov dl, 40
    mov dh, 10
    call gotoxy

    cmp al, 0
    je printCyan
    cmp al, 1
    je printYellow
    cmp al, 2
    je printWhite
    cmp al, 3
    je printGrey

    jmp printDone

printBlue:
    mwrite 'B'
    jmp printDone

printRed:
    mwrite 'R'
    jmp printDone

printGreen:
    mwrite 'G'
    jmp printDone

printMagenta:
    mwrite 'M'
    jmp printDone

printWhite:
    mwrite 'W'
    jmp printDone

printGrey:
    mwrite 'G'
    jmp printDone

printYellow:
    mwrite 'Y'
    jmp printDone

printCyan:
    mwrite 'C'
    jmp printDone

printDone:

    mov ebx, OFFSET ballColors
    mov edx, 0
    mov dl, numBalls
    add ebx, edx
    mov [ebx], al

    mov bl, projX
    mov [esi + ecx], bl
    mov bl, projY
    mov [edi + ecx], bl

    inc ballsThrown
    mov dl, 30
    mov dh, 10
    call gotoxy
    mov al, lightmagenta
    call settextcolor
    mov al, ballsThrown
    call writeint

    call RemoveThreeConsecutiveBalls

    jmp stopShooting

nextBall:
    inc esi
    inc edi
    dec ecx
    jnz collisionCheckLoop

noCollision:
    jmp drawProjectile

stopShooting:
    cmp ballsThrown, 5     
    jne stopNormally        

    mov dl, 30              
    mov dh, 10              
    call gotoxy  
    mov al, lightcyan
    call settextcolor
    mwrite 'No more balls can be thrown'

stopNormally:
    mov isShooting, 0       
    jmp endMoveProjectile

drawProjectile:
    mov dl, projX
    mov dh, projY
    call gotoxy
    mov eax,red
    call settextcolor
    mov al, projectileSymbol
    call writechar

endMoveProjectile:
    ret
MoveProjectile ENDP


RemoveThreeConsecutiveBalls PROC
    mov ecx, 0                 
    mov esi, OFFSET ballColors  
    mov edi, OFFSET ballChainX 
    mov ebx, OFFSET ballChainY 
    mov dl, numBalls            

scanChain:
    cmp cl, dl                 
    jge endRemove               

    mov al, [esi + ecx]         
    mov ah, [esi + ecx + 1]     
    cmp al, ah
    jne nextBall

    mov ah, [esi + ecx + 2]     
    cmp al, ah
    jne nextBall

   
    push ecx                    
    add ecx, 2                  

removeMatched:
    ; Clear the matched balls
    mov dl, [edi + ecx]         
    mov dh, [ebx + ecx]        
    call gotoxy                 
    mov al, emptySymbol      
    call writechar
    dec ecx                     
    cmp ecx, [esp]              
    jge removeMatched           

    pop ecx                    
    add ecx, 3                 

    
shiftRemaining:
    mov al, [esi + ecx]         
    mov [esi + ecx - 3], al
    mov al, [edi + ecx]        
    mov [edi + ecx - 3], al
    mov al, [ebx + ecx]         
    mov [ebx + ecx - 3], al
    inc ecx                     
    cmp cl, dl
    jl shiftRemaining

    sub numBalls, 3            
    mov ecx, 0                 
        call scorehehe
    
    ret                         

nextBall:
    inc ecx
    jmp scanChain

endRemove:
    ret
RemoveThreeConsecutiveBalls ENDP

end main