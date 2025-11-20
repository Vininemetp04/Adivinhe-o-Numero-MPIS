#################################
##                             ##
##  AUTORES:                   ##
##    Rafaela de Lima Castro   ##
##    Vinicius Nemet	       ##
##                             ##
#################################

# Assembly MIPS

.data 
	msg:    .asciiz "Voce tem 10 tentativas para adivinhar o numero\n"
	maior:  .asciiz "Voce chutou um numero maior!!!\n"
	menor:  .asciiz "Voce chutou um numero menor!!!\n"
    venceu: .asciiz "Voce VENCEU!!!"
    perdeu: .asciiz "Acabaram suas chances :("
	chute:  .asciiz "Qual e o seu chute: "
	max:    .byte   10

.text
.globl main

main:
	# Randomiza um número 
	li $v0, 42 	# Chamada de sistema para randomizar inteiros
	li $a1, 21	# Limite para o randomizador.
	syscall     # GALINHAAAAA
	move $t9, $a0 # Move o numero rand. para o t9
	
	# Imprime mgs na tela
	li $v0, 4
	la $a0, msg
	syscall

    # Inicia as tentativas com 0 chutes 
    li $t7, 0

loop:
    lb $t8, max # Coloca o MAX de tentativa no t8
    beq $t7, $t8, perdeu_bl # Caso t7 seja igual a t8, ou seja já usou as tetativas vai para o bloco perdeu_bl

    addi $t7, $t7, 1 # Incremento do t7 (controlador de tetativas)
    
    # Printa a mensagem de chute
    li $v0, 4   
    la $a0, chute
	syscall
    
    # Le o chute
    li $v0, 5
    syscall
    
    beq $v0, $t9, ganhou
    blt $v0, $t9, num_menor
    bgt $v0, $t9, num_maior

    j loop 

perdeu_bl:
    # Printa a mensagem de Perdeu
    li $v0, 4
    la $a0, perdeu
    syscall

    # Vai para o fim do programa
    j fim

num_maior:
    li $v0, 4
    la $a0, maior
    syscall

    j loop

num_menor:
    li $v0, 4
    la $a0, menor
    syscall

    j loop

ganhou:
    # Imprime a mensagem de comemoração
    li $v0, 4
    la $a0, venceu
    syscall

    j fim

fim:
    # Fecha o programa
    li $v0, 10
    syscall
