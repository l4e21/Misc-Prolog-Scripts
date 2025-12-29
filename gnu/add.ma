

pl_code global X0_add_two__a3
	call_c     Pl_Set_Bip_Name_Untagged_2(at(3),2)
	call_c     Pl_Math_Load_Value(X(0),&X(0))
	call_c     Pl_Math_Load_Value(X(1),&X(1))
	call_c     Pl_Fct_Add(X(0),X(1))
	move_ret   X(0)
	call_c     Pl_Unify(X(2),X(0))
	fail_ret   
	pl_ret     


pl_code global X0_add_three__a4
	call_c     Pl_Set_Bip_Name_Untagged_2(at(3),2)
	call_c     Pl_Math_Load_Value(X(0),&X(0))
	call_c     Pl_Math_Load_Value(X(1),&X(1))
	call_c     Pl_Fct_Add(X(0),X(1))
	move_ret   X(0)
	call_c     Pl_Math_Load_Value(X(2),&X(1))
	call_c     Pl_Fct_Add(X(0),X(1))
	move_ret   X(0)
	call_c     Pl_Unify(X(3),X(0))
	fail_ret   
	pl_ret     


pl_code global X0_edge__a2
	call_c     Pl_Switch_On_Term_Var_Atm(&.pred3_2,&.pred3_1)
	jump_ret   

.pred3_1:
	call_c     Pl_Switch_On_Atom(st(0),3)
	jump_ret   

.pred3_2:
	call_c     Pl_Create_Choice_Point2(&.pred3_4)

.pred3_3:
	call_c     Pl_Get_Atom_Tagged(ta(0),X(0))
	fail_ret   
	call_c     Pl_Get_Atom_Tagged(ta(1),X(1))
	fail_ret   
	pl_ret     

.pred3_4:
	call_c     Pl_Update_Choice_Point2(&.pred3_6)

.pred3_5:
	call_c     Pl_Get_Atom_Tagged(ta(1),X(0))
	fail_ret   
	call_c     Pl_Get_Atom_Tagged(ta(2),X(1))
	fail_ret   
	pl_ret     

.pred3_6:
	call_c     Pl_Delete_Choice_Point2()

.pred3_7:
	call_c     Pl_Get_Atom_Tagged(ta(2),X(0))
	fail_ret   
	call_c     Pl_Get_Atom_Tagged(ta(0),X(1))
	fail_ret   
	pl_ret     


pl_code global X0_path__a3
	call_c     Pl_Create_Choice_Point3(&.pred4_1)
	call_c     Pl_Get_List(X(2))
	fail_ret   
	call_c     Pl_Unify_Variable()
	move_ret   X(2)
	call_c     Pl_Unify_Nil()
	fail_ret   
	call_c     Pl_Get_Structure_Tagged(fn(0),X(2))
	fail_ret   
	call_c     Pl_Unify_Local_Value(X(0))
	fail_ret   
	call_c     Pl_Unify_Local_Value(X(1))
	fail_ret   
	pl_jump    X0_edge__a2

.pred4_1:
	call_c     Pl_Delete_Choice_Point3()
	call_c     Pl_Allocate(3)
	move       X(1),Y(0)
	call_c     Pl_Get_List(X(2))
	fail_ret   
	call_c     Pl_Unify_Variable()
	move_ret   X(1)
	call_c     Pl_Unify_Variable()
	move_ret   Y(2)
	call_c     Pl_Get_Structure_Tagged(fn(0),X(1))
	fail_ret   
	call_c     Pl_Unify_Local_Value(X(0))
	fail_ret   
	call_c     Pl_Unify_Variable()
	move_ret   Y(1)
	move       Y(1),X(1)
	pl_call    X0_edge__a2
	move       Y(1),X(0)
	move       Y(0),X(1)
	move       Y(2),X(2)
	call_c     Pl_Deallocate()
	pl_jump    X0_path__a3


pl_code global X0_more_than_3__a1
	call_c     Pl_Set_Bip_Name_Untagged_2(at(11),2)
	call_c     Pl_Math_Load_Value(X(0),&X(0))
	call_c     Pl_Put_Integer_Tagged(31)
	move_ret   X(1)
	call_c     Pl_Blt_Gt(X(0),X(1))
	fail_ret   
	pl_ret     


pl_code global X0_between__a1
	call_c     Pl_Allocate(1)
	move       X(0),Y(0)
	move       Y(0),X(0)
	pl_call    X0_more_than_3__a1
	call_c     Pl_Set_Bip_Name_Untagged_2(at(13),2)
	call_c     Pl_Math_Load_Value(Y(0),&X(0))
	call_c     Pl_Put_Integer_Tagged(55)
	move_ret   X(1)
	call_c     Pl_Blt_Lt(X(0),X(1))
	fail_ret   
	call_c     Pl_Deallocate()
	pl_ret     


pl_code global X0_arg__a1
	move       X(0),X(1)
	call_c     Pl_Put_Atom_Tagged(ta(3))
	move_ret   X(0)
	pl_jump    X0_gensym__a2


long local at(15)
long local ta(4)
long local fn(1)
long local st(1)


c_code  initializer Object_Initializer

	call_c     Pl_New_Object(&Prolog_Object_Initializer,&System_Directives,&User_Directives)
	c_ret      


c_code  local Prolog_Object_Initializer

	call_c     Pl_Create_Atom("/home/jam/prolog/Misc-Prolog-Scripts/gnu/add.pl")
	move_ret   at(0)
	call_c     Pl_Create_Atom("<")
	move_ret   at(13)
	call_c     Pl_Create_Atom(">")
	move_ret   at(11)
	call_c     Pl_Create_Atom("a")
	move_ret   at(6)
	call_c     Pl_Create_Atom("add_three")
	move_ret   at(4)
	call_c     Pl_Create_Atom("add_two")
	move_ret   at(1)
	call_c     Pl_Create_Atom("arg")
	move_ret   at(14)
	call_c     Pl_Create_Atom("b")
	move_ret   at(7)
	call_c     Pl_Create_Atom("between")
	move_ret   at(12)
	call_c     Pl_Create_Atom("c")
	move_ret   at(8)
	call_c     Pl_Create_Atom("edge")
	move_ret   at(5)
	call_c     Pl_Create_Atom("is")
	move_ret   at(3)
	call_c     Pl_Create_Atom("more_than_3")
	move_ret   at(10)
	call_c     Pl_Create_Atom("path")
	move_ret   at(9)
	call_c     Pl_Create_Atom("user")
	move_ret   at(2)
	call_c     Pl_Put_Atom(at(6))
	move_ret   ta(0)
	call_c     Pl_Put_Atom(at(7))
	move_ret   ta(1)
	call_c     Pl_Put_Atom(at(8))
	move_ret   ta(2)
	call_c     Pl_Create_Atom_Tagged("obj_")
	move_ret   ta(3)
	call_c     Pl_Create_Functor_Arity_Tagged("-",2)
	move_ret   fn(0)

	call_c     Pl_Create_Pred(at(1),3,at(0),4,129,&X0_add_two__a3)

	call_c     Pl_Create_Pred(at(4),4,at(0),6,129,&X0_add_three__a4)

	call_c     Pl_Create_Pred(at(5),2,at(0),9,129,&X0_edge__a2)
	call_c     Pl_Create_Swt_Table(3)
	move_ret   st(0)
	call_c     Pl_Create_Swt_Atm_Element(st(0),3,at(6),&.pred3_3)
	call_c     Pl_Create_Swt_Atm_Element(st(0),3,at(7),&.pred3_5)
	call_c     Pl_Create_Swt_Atm_Element(st(0),3,at(8),&.pred3_7)

	call_c     Pl_Create_Pred(at(9),3,at(0),13,129,&X0_path__a3)

	call_c     Pl_Create_Pred(at(10),1,at(0),16,129,&X0_more_than_3__a1)

	call_c     Pl_Create_Pred(at(12),1,at(0),17,129,&X0_between__a1)

	call_c     Pl_Create_Pred(at(14),1,at(0),19,129,&X0_arg__a1)
	c_ret      

c_code  local System_Directives

	c_ret      

c_code  local User_Directives

	c_ret      
