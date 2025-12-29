.text

fail:
	movq	2056(%r12), %rdx
	jmp	*-8(%rdx)

	.p2align	4,,15
	.type	X0_add_two__a3,@function
	.globl	X0_add_two__a3

X0_add_two__a3:
	movq	at+24(%rip), %rdi
	movq	$2, %rsi
	call	Pl_Set_Bip_Name_Untagged_2
	movq	0(%r12), %rdi
	leaq	0(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	8(%r12), %rdi
	leaq	8(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	0(%r12), %rdi
	movq	8(%r12), %rsi
	call	Pl_Fct_Add
	movq	%rax, 0(%r12)
	movq	16(%r12), %rdi
	movq	0(%r12), %rsi
	call	Pl_Unify
	test	%rax, %rax
	je	fail
	jmp	*2080(%r12)

	.p2align	4,,15
	.type	X0_add_three__a4,@function
	.globl	X0_add_three__a4

X0_add_three__a4:
	movq	at+24(%rip), %rdi
	movq	$2, %rsi
	call	Pl_Set_Bip_Name_Untagged_2
	movq	0(%r12), %rdi
	leaq	0(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	8(%r12), %rdi
	leaq	8(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	0(%r12), %rdi
	movq	8(%r12), %rsi
	call	Pl_Fct_Add
	movq	%rax, 0(%r12)
	movq	16(%r12), %rdi
	leaq	8(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	0(%r12), %rdi
	movq	8(%r12), %rsi
	call	Pl_Fct_Add
	movq	%rax, 0(%r12)
	movq	24(%r12), %rdi
	movq	0(%r12), %rsi
	call	Pl_Unify
	test	%rax, %rax
	je	fail
	jmp	*2080(%r12)

	.p2align	4,,15
	.type	X0_edge__a2,@function
	.globl	X0_edge__a2

X0_edge__a2:
	leaq	.Lpred3_2+0(%rip), %rdi
	leaq	.Lpred3_1+0(%rip), %rsi
	call	Pl_Switch_On_Term_Var_Atm
	jmp	*%rax

.Lpred3_1:
	movq	st+0(%rip), %rdi
	movq	$3, %rsi
	call	Pl_Switch_On_Atom
	jmp	*%rax

.Lpred3_2:
	leaq	.Lpred3_4+0(%rip), %rdi
	call	Pl_Create_Choice_Point2

.Lpred3_3:
	movq	ta+0(%rip), %rdi
	movq	0(%r12), %rsi
	call	Pl_Get_Atom_Tagged
	test	%rax, %rax
	je	fail
	movq	ta+8(%rip), %rdi
	movq	8(%r12), %rsi
	call	Pl_Get_Atom_Tagged
	test	%rax, %rax
	je	fail
	jmp	*2080(%r12)

.Lpred3_4:
	leaq	.Lpred3_6+0(%rip), %rdi
	call	Pl_Update_Choice_Point2

.Lpred3_5:
	movq	ta+8(%rip), %rdi
	movq	0(%r12), %rsi
	call	Pl_Get_Atom_Tagged
	test	%rax, %rax
	je	fail
	movq	ta+16(%rip), %rdi
	movq	8(%r12), %rsi
	call	Pl_Get_Atom_Tagged
	test	%rax, %rax
	je	fail
	jmp	*2080(%r12)

.Lpred3_6:
	call	Pl_Delete_Choice_Point2

.Lpred3_7:
	movq	ta+16(%rip), %rdi
	movq	0(%r12), %rsi
	call	Pl_Get_Atom_Tagged
	test	%rax, %rax
	je	fail
	movq	ta+0(%rip), %rdi
	movq	8(%r12), %rsi
	call	Pl_Get_Atom_Tagged
	test	%rax, %rax
	je	fail
	jmp	*2080(%r12)

	.p2align	4,,15
	.type	X0_path__a3,@function
	.globl	X0_path__a3

X0_path__a3:
	leaq	.Lpred4_1+0(%rip), %rdi
	call	Pl_Create_Choice_Point3
	movq	16(%r12), %rdi
	call	Pl_Get_List
	test	%rax, %rax
	je	fail
	call	Pl_Unify_Variable
	movq	%rax, 16(%r12)
	call	Pl_Unify_Nil
	test	%rax, %rax
	je	fail
	movq	fn+0(%rip), %rdi
	movq	16(%r12), %rsi
	call	Pl_Get_Structure_Tagged
	test	%rax, %rax
	je	fail
	movq	0(%r12), %rdi
	call	Pl_Unify_Local_Value
	test	%rax, %rax
	je	fail
	movq	8(%r12), %rdi
	call	Pl_Unify_Local_Value
	test	%rax, %rax
	je	fail
	jmp	X0_edge__a2

.Lpred4_1:
	call	Pl_Delete_Choice_Point3
	movq	$3, %rdi
	call	Pl_Allocate
	movq	8(%r12), %rdx
	movq	2088(%r12), %rbx
	movq	%rdx, -32(%rbx)
	movq	16(%r12), %rdi
	call	Pl_Get_List
	test	%rax, %rax
	je	fail
	call	Pl_Unify_Variable
	movq	%rax, 8(%r12)
	call	Pl_Unify_Variable
	movq	%rax, -48(%rbx)
	movq	fn+0(%rip), %rdi
	movq	8(%r12), %rsi
	call	Pl_Get_Structure_Tagged
	test	%rax, %rax
	je	fail
	movq	0(%r12), %rdi
	call	Pl_Unify_Local_Value
	test	%rax, %rax
	je	fail
	call	Pl_Unify_Variable
	movq	%rax, -40(%rbx)
	movq	-40(%rbx), %rdx
	movq	%rdx, 8(%r12)
	leaq	.Lcont1(%rip), %r10
	movq	%r10, 2080(%r12)
	jmp	X0_edge__a2
.Lcont1:
	movq	2088(%r12), %rbx
	movq	-40(%rbx), %rdx
	movq	%rdx, 0(%r12)
	movq	-32(%rbx), %rdx
	movq	%rdx, 8(%r12)
	movq	-48(%rbx), %rdx
	movq	%rdx, 16(%r12)
	call	Pl_Deallocate
	jmp	X0_path__a3

	.p2align	4,,15
	.type	X0_more_than_3__a1,@function
	.globl	X0_more_than_3__a1

X0_more_than_3__a1:
	movq	at+88(%rip), %rdi
	movq	$2, %rsi
	call	Pl_Set_Bip_Name_Untagged_2
	movq	0(%r12), %rdi
	leaq	0(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	$31, %rdi
	call	Pl_Put_Integer_Tagged
	movq	%rax, 8(%r12)
	movq	0(%r12), %rdi
	movq	8(%r12), %rsi
	call	Pl_Blt_Gt
	test	%rax, %rax
	je	fail
	jmp	*2080(%r12)

	.p2align	4,,15
	.type	X0_between__a1,@function
	.globl	X0_between__a1

X0_between__a1:
	movq	$1, %rdi
	call	Pl_Allocate
	movq	0(%r12), %rdx
	movq	2088(%r12), %rbx
	movq	%rdx, -32(%rbx)
	movq	-32(%rbx), %rdx
	movq	%rdx, 0(%r12)
	leaq	.Lcont2(%rip), %r10
	movq	%r10, 2080(%r12)
	jmp	X0_more_than_3__a1
.Lcont2:
	movq	at+104(%rip), %rdi
	movq	$2, %rsi
	call	Pl_Set_Bip_Name_Untagged_2
	movq	2088(%r12), %rbx
	movq	-32(%rbx), %rdi
	leaq	0(%r12), %rsi
	call	Pl_Math_Load_Value
	movq	$55, %rdi
	call	Pl_Put_Integer_Tagged
	movq	%rax, 8(%r12)
	movq	0(%r12), %rdi
	movq	8(%r12), %rsi
	call	Pl_Blt_Lt
	test	%rax, %rax
	je	fail
	call	Pl_Deallocate
	jmp	*2080(%r12)

	.p2align	4,,15
	.type	X0_arg__a1,@function
	.globl	X0_arg__a1

X0_arg__a1:
	movq	0(%r12), %rdx
	movq	%rdx, 8(%r12)
	movq	ta+24(%rip), %rdi
	call	Pl_Put_Atom_Tagged
	movq	%rax, 0(%r12)
	jmp	X0_gensym__a2

	.p2align	4,,15
	.type	Object_Initializer,@function

Object_Initializer:
	pushq	%rbx
	subq	$256, %rsp
	leaq	Prolog_Object_Initializer+0(%rip), %rdi
	leaq	System_Directives+0(%rip), %rsi
	leaq	User_Directives+0(%rip), %rdx
	call	Pl_New_Object
	addq	$256, %rsp
	popq	%rbx
	ret	

	.p2align	4,,15
	.type	Prolog_Object_Initializer,@function

Prolog_Object_Initializer:
	pushq	%rbx
	subq	$256, %rsp
	leaq	.LC0(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+0(%rip)
	leaq	.LC1(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+104(%rip)
	leaq	.LC2(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+88(%rip)
	leaq	.LC3(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+48(%rip)
	leaq	.LC4(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+32(%rip)
	leaq	.LC5(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+8(%rip)
	leaq	.LC6(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+112(%rip)
	leaq	.LC7(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+56(%rip)
	leaq	.LC8(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+96(%rip)
	leaq	.LC9(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+64(%rip)
	leaq	.LC10(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+40(%rip)
	leaq	.LC11(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+24(%rip)
	leaq	.LC12(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+80(%rip)
	leaq	.LC13(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+72(%rip)
	leaq	.LC14(%rip), %rdi
	call	Pl_Create_Atom
	movq	%rax, at+16(%rip)
	movq	at+48(%rip), %rdi
	call	Pl_Put_Atom
	movq	%rax, ta+0(%rip)
	movq	at+56(%rip), %rdi
	call	Pl_Put_Atom
	movq	%rax, ta+8(%rip)
	movq	at+64(%rip), %rdi
	call	Pl_Put_Atom
	movq	%rax, ta+16(%rip)
	leaq	.LC15(%rip), %rdi
	call	Pl_Create_Atom_Tagged
	movq	%rax, ta+24(%rip)
	leaq	.LC16(%rip), %rdi
	movq	$2, %rsi
	call	Pl_Create_Functor_Arity_Tagged
	movq	%rax, fn+0(%rip)
	movq	at+8(%rip), %rdi
	movq	$3, %rsi
	movq	at+0(%rip), %rdx
	movq	$4, %rcx
	movq	$129, %r8
	leaq	X0_add_two__a3+0(%rip), %r9
	call	Pl_Create_Pred
	movq	at+32(%rip), %rdi
	movq	$4, %rsi
	movq	at+0(%rip), %rdx
	movq	$6, %rcx
	movq	$129, %r8
	leaq	X0_add_three__a4+0(%rip), %r9
	call	Pl_Create_Pred
	movq	at+40(%rip), %rdi
	movq	$2, %rsi
	movq	at+0(%rip), %rdx
	movq	$9, %rcx
	movq	$129, %r8
	leaq	X0_edge__a2+0(%rip), %r9
	call	Pl_Create_Pred
	movq	$3, %rdi
	call	Pl_Create_Swt_Table
	movq	%rax, st+0(%rip)
	movq	st+0(%rip), %rdi
	movq	$3, %rsi
	movq	at+48(%rip), %rdx
	leaq	.Lpred3_3+0(%rip), %rcx
	call	Pl_Create_Swt_Atm_Element
	movq	st+0(%rip), %rdi
	movq	$3, %rsi
	movq	at+56(%rip), %rdx
	leaq	.Lpred3_5+0(%rip), %rcx
	call	Pl_Create_Swt_Atm_Element
	movq	st+0(%rip), %rdi
	movq	$3, %rsi
	movq	at+64(%rip), %rdx
	leaq	.Lpred3_7+0(%rip), %rcx
	call	Pl_Create_Swt_Atm_Element
	movq	at+72(%rip), %rdi
	movq	$3, %rsi
	movq	at+0(%rip), %rdx
	movq	$13, %rcx
	movq	$129, %r8
	leaq	X0_path__a3+0(%rip), %r9
	call	Pl_Create_Pred
	movq	at+80(%rip), %rdi
	movq	$1, %rsi
	movq	at+0(%rip), %rdx
	movq	$16, %rcx
	movq	$129, %r8
	leaq	X0_more_than_3__a1+0(%rip), %r9
	call	Pl_Create_Pred
	movq	at+96(%rip), %rdi
	movq	$1, %rsi
	movq	at+0(%rip), %rdx
	movq	$17, %rcx
	movq	$129, %r8
	leaq	X0_between__a1+0(%rip), %r9
	call	Pl_Create_Pred
	movq	at+112(%rip), %rdi
	movq	$1, %rsi
	movq	at+0(%rip), %rdx
	movq	$19, %rcx
	movq	$129, %r8
	leaq	X0_arg__a1+0(%rip), %r9
	call	Pl_Create_Pred
	addq	$256, %rsp
	popq	%rbx
	ret	

	.p2align	4,,15
	.type	System_Directives,@function

System_Directives:
	pushq	%rbx
	subq	$256, %rsp
	addq	$256, %rsp
	popq	%rbx
	ret	

	.p2align	4,,15
	.type	User_Directives,@function

User_Directives:
	pushq	%rbx
	subq	$256, %rsp
	addq	$256, %rsp
	popq	%rbx
	ret	
	.section	.ctors,"aw",@progbits
	.align	8
	.quad	Object_Initializer
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC16:
	.string	"-"
.LC0:
	.string	"/home/jam/prolog/Misc-Prolog-Scripts/gnu/add.pl"
.LC1:
	.string	"<"
.LC2:
	.string	">"
.LC3:
	.string	"a"
.LC4:
	.string	"add_three"
.LC5:
	.string	"add_two"
.LC6:
	.string	"arg"
.LC7:
	.string	"b"
.LC8:
	.string	"between"
.LC9:
	.string	"c"
.LC10:
	.string	"edge"
.LC11:
	.string	"is"
.LC12:
	.string	"more_than_3"
.LC15:
	.string	"obj_"
.LC13:
	.string	"path"
.LC14:
	.string	"user"
.data
	.align	16
	.local	at
	.comm	at,120,8
	.local	fn
	.comm	fn,8,8
	.local	st
	.comm	st,8,8
	.local	ta
	.comm	ta,32,8
	.section	.note.GNU-stack,"",@progbits
