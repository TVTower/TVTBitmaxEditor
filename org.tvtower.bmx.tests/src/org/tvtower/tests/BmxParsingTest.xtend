/*
 * generated by Xtext 2.23.0
 */
package org.tvtower.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.tvtower.bmx.BmxFile

@ExtendWith(InjectionExtension)
@InjectWith(BmxInjectorProvider)
class BmxParsingTest {
	@Inject
	ParseHelper<BmxFile> parseHelper

	@Test
	def void comments() {
		'''
			'this is a comment
			SuperStrict 'this too
			Rem
				And this is a 
				multiline comment
			EndRem
			rem
				unfortunately the ignore case does not seem to apply to terminals...
			ENDREM
		'''.noErrors
		
	}

	@Test
	def void splitEndRem() {
		'''
			Rem
				really?? 
			End Rem
			Rem
				really?? 
			END REM
			Rem
				really?? 
			end rem
		'''.noErrors
		
	}

	@Test
	def void ignoreCase() {
		'''sUpErStRiCt'''.noErrors
	}

	@Test
	def void imports() {
		'''
			import "tada.bmx"
			include "bla.bmx"
			incbin "tidum.bmx"
		'''.noErrors
	}

	@Test
	def void compilerOptions() {
		'''
			?bmx
			import "tada.bmx"
			?not bmx
			include "bla.bmx"
			?
			incbin "tidum.bmx"
		'''.noErrors
	}

	@Test
	def void topLevelElements() {
		'''
			import "tada.bmx"
			SuperStrict
			private
			Local v1:int
			Strict
			fct.call()

			public
			Struct str
				Field strF
				Function fct:int()
				EndFunction

				Method m:int()
				End Method
			End Struct
		'''.noErrors
	}

	@Test
	def void simpleType() {
		'''
			Type MyType
				Method AbstractMethod1() abstract

				Method AbstractMethod2:int() abstract

				Method m1()
				End Method

				Method m1:int()
					Return 20
				End Method

			End Type

			Type MyOtherType
				Function RemoveSomething()
				End Function

				Function RemoveSomething:int()
					Return 20
				End Function
			End Type
		'''.noErrors
	}

	@Test
	def void nestedFunctions() {
		'''
		Type MyType
			Method m1()
				x=f()
				Function f:int()
					return 1
				End Function
			End Method
		EndType
		'''.noErrors
	}

	@Test
	def void simpleFields() {
		'''
			Type MyType
				Field f1:int, f1_1:String, f1_2:float
				Field ReadOnly f2:Int = 0
				Field f3:int = Some.CONSTANT
				Field f4:String
				Field f4:String = ""
				Field f5:String = "s1" + "s2"
				Field f6:String = New SomeType.Create("init")
				Field f7:String = New SomeType.Create("init", 230, TRUE)
				Field f8:int = -1.23
				Field f9:int = fct.call(a + b, b - c, -1)
			End Type
		'''.noErrors
	}

	@Test
	def void pointer() {
		'''
			Type MyType
				Field f1:Byte Ptr
				Function read:Byte Ptr(buf:Byte, size:Int)
				End Function
				Function read:Byte Ptr(buf:Byte Ptr, size:Int)
				End Function
				Function read:Byte Ptr(buf:Byte Var, size:Int)
				End Function
			End Type
		'''.noErrors
	}

	@Test
	def void callback() {
		'''
			Type MyType
				Field f(t:String)
				Field f:int(m:float)
				Field farray:int(m:float)[]
				Global g:int(t:String)
			End Type
		'''.noErrors
	}

	@Test
	def void extern() {
		'''
			Extern "C"
				Const c
				Function f:int(p1:int)
				Global g:int
				Function f2:String() = "tada"
			End Extern
		'''.noErrors
	}

	@Test
	def void enumDef() {
		'''
			Enum AnEnum:Byte
				Val1
				Val2=2
				Val3=7
			End Enum
		'''.noErrors
	}

	@Test
	def void ellipse() {
		'''
			Type MyType
				Field f1 ...
				Const c ...
				Const noValue
			End Type
		'''.noErrors
	}

	@Test
	def void arrays() {
		'''
			Type MyType
				Field f1:int[15]
				Field f2:int[] = [1, fct.call(1,[1,2])]
				Field StaticArray f3:int[][]
				Field f4:int[,]
			End Type
		'''.noErrors
		}

	@Test
	def void functionParameters() {
		'''
			Function f0:int(noType)
			End Function

			Function f1:int(param1:String, arr:int[] var)
			End Function

			Function f2:int(param1:String[]= ["1","2"])
			End Function

			Function f3:int(param1:int = 5, param2:String=New Call.Fkt("tada"))
			End Function

			Function f4:int(param1:int(cb:String,cb2:int), param1(cb:String,cb2:int), param2:String=New Call.Fkt("tada"))
			End Function
		'''.noErrors
	}
	@Test
	def void parameterContinue() {
		'''
			Function f0:int(param1:int, ..
				param2:string, ..
				param3:byte)
				return 0
			End Function
		'''.noErrors
	}

	@Test
	def void select() {
		'''
			Function someSelect(num:int)
				Select num
					Case 1
						Return 1
					Default
						Return 2
					End Select
				Select num
					Case 2
						Return 2
					Default
						Return 3
					EndSelect
			End Function
		'''.noErrors
	}

	@Test
	def void whileBlock() {
		'''
			Function someSelect(num:int)
				While 1=1
					print "tada"
				End While
				While 2=2
					print "tidum"
				Wend
			End Function
		'''.noErrors
	}

	@Test
	def void ifs(){
		'''
			Function someIf(num:int)
				If num = 1
					Local i:int=1
					Return 1
				Else If num < 5
					Global j:int=7
					If num = 2 Then Return 2
					If num = 3
						return 3
					Else
						return 4
					End If
				Else
					return num
				End If
			End Function
		'''.noErrors
	}

	@Test
	def void exits(){
		'''
			Function someIf(num:int)
				If num = 1
					end
				Else If num < 5
					End
				End If
			End Function
		'''.noErrors
	}

	@Test
	def void tryCatch() {
		'''
			Function someSelect(num:int)
				try
					print "tada"
					catch ex: object
				end try
			End Function
		'''.noErrors
	}

	@Test
	def void parenthesized() {
		'''
			Function someSelect(num:int)
				Super.callFunction()
			End Function
		'''.noErrors
	}

	@Test
	def void emptyParam() {
		'''
			Function someFct(num:object)
				object.call(param1, , parm3)
			End Function
		'''.noErrors
	}

	@Test
	def void annotations() {
		'''
			Type MyType {_exposeToLua}
				Global f: int {noSave}
				Field f:String="" {noSave}
				Method m1() {_exposeToLua="selected"}
				End Method

				Method m2:int() abstract {_exposeToLua}

				Function f1:int() {_exposeToLua}
					return 1
				End Function

			End Type
		'''.noErrors
	}

	def void noErrors(CharSequence content){
		val result = parseHelper.parse(content)
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
