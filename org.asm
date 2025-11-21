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
    venceu: .asciiz "Voce VENCEU!!!\n"
    perdeu: .asciiz "Acabaram suas chances :(\n"
	chute:  .asciiz "Qual e o seu chute: "
	max:    .byte   10
    menu_1: .asciiz "=-=-=-=-=| MENU |=-=-=-=-=\n"
    menu_2: .asciiz "Maior pontuação: "
    menu_3: .asciiz "1 - Jogar\n"
    menu_4: .asciiz "0 - Sair\n"
    menu_5: .asciiz "Sua opção: "
    menu_0: .asciiz "-\n"
    menu_n: .asciiz "\n"

.text
.globl main

main:
    li $t5, 0 # Inicia a melhor pontuação com 0.
    j menu

rand_num:
    # Randomiza um número 
	li $v0, 42 	  # Chamada de sistema para randomizar inteiros
	li $a1, 21	  # Limite para o randomizador.
	syscall       # GALINHAAAAA
	move $t9, $a0 # Move o numero rand. para o t9
    
    # Volta para onde chamou
    jr $ra

#
# Blocos do menu
#

menu:
    li $t7, 0 # Inicia as tentativas com 0 chutes

    # Pinrta dodas as linhas do menu
    li $v0, 4
    la $a0, menu_1 
    syscall
    la $a0, menu_2 
    syscall
    
    # Se o $5 == 0 escreve - (menu_init) se não escre a pontuação (menu_pont)
    beq $t5, $zero, menu_init
    j menu_pont

menu_op:
    # Escreve opções
    li $v0, 4
    la $a0, menu_3
    syscall
    la $a0, menu_4
    syscall
    la $a0, menu_5
    syscall

    # Le opção
    li $v0, 5
    syscall

    beq $v0, $zero, fim
    
    # Imprime mgs na tela
	li $v0, 4
	la $a0, msg
	syscall
    
    jal rand_num
    j loop

menu_init:
    # Escreve '-' já que não teve jogo anterior
    li $v0, 4
    la $a0, menu_0
    syscall
    
    # Continua para o menu
    j menu_op

menu_pont:
    # Escreve a melhor pontuação
    li $v0, 1
    move $a0, $t5
    syscall
    
    # Nova linha
    li $v0, 4
    la $a0, menu_n
    syscall

    # Continua para o menu
    j menu_op

#
# Blocos do jogo
#

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
   
    # Condições 
    beq $v0, $t9, ganhou    # Acertou o número
    blt $v0, $t9, num_menor # Chutou um número menor
    bgt $v0, $t9, num_maior # Chutou um número MAIOR

    j loop 

num_maior:
    # Escreve que o chute foi MAIOR
    li $v0, 4
    la $a0, maior
    syscall

    j loop

num_menor:
    # Escreve q o chute foi menor
    li $v0, 4
    la $a0, menor
    syscall

    j loop

ganhou:
    # Imprime a mensagem de comemoração
    li $v0, 4
    la $a0, venceu
    syscall
    
    # Salva melhor pontuação (menor número de chutes)
    beq $t5, $zero, registra
    blt $t7, $t5, registra

    # Volta para o menu.
    j menu 

registra:
    # Registra a melhor pontuação
    move $t5, $t7
    j menu

perdeu_bl:
    # Printa a mensagem de Perdeu
    li $v0, 4
    la $a0, perdeu
    syscall

    # Vai para o menu do programa
    j menu 

fim:
    # Fecha o programa
    li $v0, 10
    syscall
