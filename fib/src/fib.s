	.syntax unified
 	.cpu cortex-m0
 	.align	2
 	.global	fibonacci
 	.thumb
 	.thumb_func
 fibonacci:
 	push {lr}
 fib_recur:
	subs r0,r0,#1 //subtract 1 from the index
	adds r3,r2,#0 //store higher fib number into r3
	add r2,r2,r1 //calculate next fib number
	mov r1, r3 //store old higher fib number into r1
	cmp r0,#1 //compare index with 0
	bgt fib_recur //recursively iterate through fib sequence

	mov r0, r2
	pop {pc}
