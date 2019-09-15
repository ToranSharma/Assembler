.data
	greeting:
		.ascii "Hello! What's your name?\n"
	greeting_len = . - greeting
	
	response:
		.ascii "Hello , it is nice to meet you!\n" /* the name will want to be input after the 6th byte? */
	response_len = . - response

	name:
		.skip 20


.text

.global _start

_start:
	/* Write greeting */
	mov x0, #1					/* Destination file descriptor 0 -> stdin, 1 -> stdout, 2 -> stderr */
	ldr x1, =greeting			/* Pointer to text start */
	ldr x2, =greeting_len		/* Length of text */
	mov x8, #64					/* Syscall code for write */
	svc #0						/* Envoke write syscall */

read:
	mov x0, #0					/* stdin */
	ldr x1, =name				/* Buffer start pointer */
	mov x2, #20					/* Max buffer length*/
	mov x8, #63					/* Syscall code for read */
	svc #0						/* Envoke read syscall*/

	str x0, [sp, #16]!			/* x0 will hold result of length of input text from read, let's save it on the stack */

respond:
	mov x0, #1					/* stdout */
	ldr x1, =response			/* Pointer to text start */
	mov x2, 6					/* Only write first 6 bytes of response message to just print "hello " */
	mov x8, #64					/* Syscall code for write */
	svc #0						/* Envoke write syscall */
	
	mov x0, #1					/* stdout */
	ldr x1, =name				/* Pointer to start of buffer */
	ldr x2, [sp], #-16			/* Pop the input length off the stack and into x2 for the length of the write */
	sub x2, x2, #1              /* Take 1 off the length to ignore the line break */
	mov x8, #64					/* Syscall code for write*/
	svc #0						/* Envoke write syscall */

	mov x0, #1					/* stdout */
	ldr x1, =response			/* Pointer to text start */
	add x1, x1, #6				/* Offest pointer to just after "Hello " */
	ldr x2, =response_len		/* Length of response */
	sub x2, x2, #6				/* Take the offest off of the length */
	mov x8, #64					/* Syscall code for write */
	svc #0						/* Envoke write syscall */	

exit:
	mov x0, #0					/* Exit value for success */
	mov x8, #93					/* Syscall code for exit */
	svc #0						/* Envoke exit syscall */
